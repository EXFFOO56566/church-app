<?php
if(!defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Verify_model extends CI_Model{
    public $status = 'error';
    public $message = 'Something went wrong';


//insert verification details to the db
   public function insertData($data){
     //$data[':createdDtm'] = date('Y-m-d H:i:s');
     //$sql = "INSERT INTO tbl_verification (email, activation_id,agent,client_ip,createdDtm) VALUES (:email, :activation_id,:agent,:client_ip,:createdDtm)";
     //$stmt= $this->db->conn_id->prepare($sql);
     //$stmt->execute($data);
     $this->db->trans_start();
     $this->db->insert('tbl_verification', $data);
     $this->db->trans_complete();
   }

//check if verification details exists, when user clicks on the link sent to mail
   public function checkActivationDetails($email,$activation_id){
     //$stmt = $this->db->conn_id->prepare("SELECT * FROM tbl_verification WHERE email=? AND activation_id=?");
     //$stmt->execute([$email,$activation_id]);
     //$row = $stmt->fetch(PDO::FETCH_OBJ);
     $this->db->select('tbl_verification.*');
     $this->db->from('tbl_verification');
     $this->db->where('email',$email);
     $this->db->where('activation_id',$activation_id);
     $query = $this->db->get();
     $row = $query->row();
      if($row){
        return TRUE;
      }
      return FALSE;
   }

  //delete details when user have been verified
   public function deleteActivationDetails($email,$activation_id){
     //$stmt = $this->db->conn_id->prepare("DELETE FROM tbl_verification WHERE email=? AND activation_id=?");
     //$stmt->execute([$email,$activation_id]);
     $this->db->where('email',$email);
     $this->db->where('activation_id',$activation_id);
     $this->db->delete('tbl_verification');
      $this->status = 'ok';
   }

}
