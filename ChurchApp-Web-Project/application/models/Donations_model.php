<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Donations_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    function donationsListing($columnName,$columnSortOrder,$searchValue,$start, $length){
      $this->db->select('tbl_donations.*');
      $this->db->from('tbl_donations');
      if($searchValue!=""){
        $this->db->like('name', $searchValue);
        $this->db->or_like('email', $searchValue);
        $this->db->or_like('reference', $searchValue);
        $this->db->or_like('amount', $searchValue);
      }
      if($columnName!=""){
         $this->db->order_by($columnName, $columnSortOrder);
      }
      $this->db->limit($length,$start);
      $query = $this->db->get();
      return $query->result();
    }

    public function get_total_donations($searchValue=""){
      if($searchValue==""){
        $query = $this->db->select("COUNT(*) as num")->get("tbl_donations");
      }else{
        $this->db->select("COUNT(*) as num");
        $this->db->from('tbl_donations');
        $this->db->like('name', $searchValue);
        $this->db->or_like('email', $searchValue);
        $this->db->or_like('reference', $searchValue);
        $this->db->or_like('amount', $searchValue);
        $query = $this->db->get();
      }
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }


  public function recordDonation($ref){
   if($this->verifyPaymentRefExists($ref['email'],$ref['reference']) == FALSE){
     $this->db->trans_start();
     $this->db->insert('tbl_donations', $ref);
     $this->db->trans_complete();
     $this->status = "ok";
      $this->message = "Donation was done successfully";
   }else{
     $this->status = "error";
     $this->message = "Cannot record the donation made at the moment";
   }
  }


  function verifyPaymentRefExists($email,$ref)
  {
      $this->db->select('tbl_donations.id');
      $this->db->from('tbl_donations');
      $this->db->where('email',$email);
      $this->db->where('reference',$ref);
      $query = $this->db->get();
      if(count((array)$query->row())>0){
        return TRUE;
      }
      return FALSE;
  }

  function getSettings(){
      $this->db->select('tbl_donation_settings.*');
      $this->db->from('tbl_donation_settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row();
  }


  function updateSettings($data){
      $this->db->where('id', 100);
      $this->db->update('tbl_donation_settings', $data);
      $this->status = 'ok';
      $this->message = 'Donations Settings updated successfully';
  }

}
