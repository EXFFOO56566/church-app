<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Coupons_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

   function couponsListing(){
       $this->db->select('tbl_coupons.*');
       $this->db->from('tbl_coupons');
       $this->db->order_by('id','DESC');
       $query = $this->db->get();
       return $query->result();
   }

   function couponsDurationListing($duration,$currency,$start=0,$limit=20){
       $this->db->select('tbl_coupons.*');
       $this->db->from('tbl_coupons');
       $this->db->where('duration', $duration);
       $this->db->order_by('id','ASC');
       $this->db->limit($limit,$start);
       $query = $this->db->get();
       $result = $query->result_array();
       $items = [];
       foreach ($result as $res) {
         $res['currency'] = $currency;
         array_push($items, $res);
       }
       //var_dump($items); die;
       return $items;
   }


   function checkCouponCodeExists($code){
       $this->db->select("id");
       $this->db->from("tbl_coupons");
       $this->db->where("code", $code);
       $query = $this->db->get();
       if($query->row()){
         return TRUE;
       }else{
         return FALSE;
       }
   }

   function fetchCoupon($code){
       $this->db->select("tbl_coupons.*");
       $this->db->from("tbl_coupons");
       $this->db->where("code", $code);
       $query = $this->db->get();
       return $query->row();
   }


   function addNewCoupon($info)
   {
     $this->db->trans_start();
     $this->db->insert('tbl_coupons', $info);
     $this->db->trans_complete();
   }

   function deleteCouponWithCode($code){
       $this->db->where('code', $code);
       $this->db->delete('tbl_coupons');
   }

   function deleteCoupon($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_coupons');
        $this->status = 'ok';
        $this->message = 'Coupon Code deleted successfully.';
   }

   function deleteGroupCoupons($duration){
       $this->db->where('duration', $duration);
       $this->db->delete('tbl_coupons');
        $this->status = 'ok';
        $this->message = 'Coupon Codes deleted successfully.';
   }
}
