<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Coins_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function get_total_coins(){
      $query = $this->db->select("COUNT(*) as num")->get("tbl_coins");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   function coinsListing(){
       $this->db->select('tbl_coins.*');
       $this->db->from('tbl_coins');
       $this->db->order_by('amount','ASC');
       $query = $this->db->get();
       $result = $query->result();
       return $result;
   }


   function addNewCoin($info)
   {
     $this->db->trans_start();
     $this->db->insert('tbl_coins', $info);
     $this->db->trans_complete();
     $this->status = 'ok';
     $this->message = 'Coins added successfully';
   }


   function editCoins($info, $id){
     $this->db->where('id', $id);
     $this->db->update('tbl_coins', $info);
     $this->status = 'ok';
     $this->message = 'Coins edited successfully';
   }


   function getCoinsInfo($id)
   {
       $this->db->select('tbl_coins.*');
       $this->db->from('tbl_coins');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       return $row;
   }


   function deleteCoins($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_coins');
        $this->status = 'ok';
        $this->message = 'Coins deleted successfully.';
   }

   function purchaseListing($columnName,$columnSortOrder,$searchValue,$start, $length){
     $this->db->select('tbl_coin_purchases.*, tbl_coins.name');
     $this->db->from('tbl_coin_purchases');
     $this->db->join('tbl_coins','tbl_coins.id=tbl_coin_purchases.coin_id');
     if($searchValue!=""){
         $this->db->like('name', $searchValue);
     }
     if($columnName!=""){
        $this->db->order_by($columnName, $columnSortOrder);
     }
     $this->db->limit($length,$start);
     $query = $this->db->get();
     return $query->result();
   }

   public function get_total_purchases($searchValue=""){
     if($searchValue==""){
       $query = $this->db->select("COUNT(*) as num")->get("tbl_coin_purchases");
     }else{
       $this->db->select("COUNT(*) as num");
       $this->db->from('tbl_coin_purchases');
       $this->db->like('name', $searchValue);
       $query = $this->db->get();
     }
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

  public function recordPayment($ref){
   if($this->verifyPaymentRefExists($ref['email'],$ref['reference']) == FALSE){
     $this->db->trans_start();
     $this->db->insert('tbl_coin_purchases', $ref);
     $this->db->trans_complete();
     $this->status = "ok";
   }else{
     $this->status = "error";
   }
  }

  public function recordPurchase($ref){
   if($this->verifyPurchaseRefExists($ref['email'],$ref['media_id']) == FALSE){
     $this->db->trans_start();
     $this->db->insert('tbl_media_purchases', $ref);
     $this->db->trans_complete();
     $this->status = "ok";
   }else{
     $this->status = "error";
   }
  }

  function decrementUserCoins($email,$value){
    $this->db->set('user_coins', '`user_coins`- '.$value, false);
    $this->db->where('email' , $email);
    $this->db->update('tbl_android_users');
  }

  function incrementUserCoins($email,$value){
    $this->db->set('user_coins', '`user_coins`+ '.$value, false);
    $this->db->where('email' , $email);
    $this->db->update('tbl_android_users');
  }

  function verifyPurchaseRefExists($email,$media)
  {
      $this->db->select('tbl_media_purchases.id');
      $this->db->from('tbl_media_purchases');
      $this->db->where('email',$email);
      $this->db->where('media_id',$media);
      $query = $this->db->get();
      if(count((array)$query->row())>0){
        return TRUE;
      }
      return FALSE;
  }

  function verifyPaymentRefExists($email,$ref)
  {
      $this->db->select('tbl_coin_purchases.id');
      $this->db->from('tbl_coin_purchases');
      $this->db->where('email',$email);
      $this->db->where('reference',$ref);
      $query = $this->db->get();
      if(count((array)$query->row())>0){
        return TRUE;
      }
      return FALSE;
  }

  public function fetch_user_purchases($page = 0,$email="null"){
    $this->db->select('tbl_coin_purchases.*, tbl_coins.name');
    $this->db->from('tbl_coin_purchases');
    $this->db->join('tbl_coins','tbl_coins.id=tbl_coin_purchases.coin_id');
      $this->db->where('tbl_coin_purchases.email',$email);
      $this->db->order_by('date','desc');

      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      return $query->result();
  }

  public function total_user_purchases($email){
    $this->db->select("COUNT(*) as num");
    $this->db->where('email',$email);
    $query = $this->db->get("tbl_coin_purchases");
    $result = $query->row();
    if(isset($result)) return $result->num;
    return 0;
   }

}
