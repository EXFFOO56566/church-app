<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Inbox_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function get_total_inbox($last_seen_inbox=0){
      $this->db->select("COUNT(*) as num");
      $this->db->from('tbl_inbox');
      $this->db->where('id >',$last_seen_inbox);
      $query = $this->db->get();
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   function fetchInbox($page=0){
       $this->db->select('tbl_inbox.*');
       $this->db->from('tbl_inbox');
       $this->db->order_by('date','desc');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       return $result;
   }


   function inboxListing(){
     $this->db->select('tbl_inbox.*');
     $this->db->from('tbl_inbox');
     $this->db->order_by('date','desc');
       $query = $this->db->get();
       $result = $query->result();
       return $result;
   }

   function getInboxData($id)
   {
     $this->db->select('tbl_inbox.*');
     $this->db->from('tbl_inbox');
     $this->db->where('id', $id);
     $query = $this->db->get();
     $row = $query->row();
     if(count((array)$row) > 0){
       $row->message = strip_tags($row->message);
     }
       //echo $row->source; die;
       return $row;
   }


   function addNewInbox($info)
   {
     $insert_id = 0;
     $this->db->trans_start();
     $this->db->insert('tbl_inbox', $info);
     $insert_id = $this->db->insert_id();
     $this->db->trans_complete();
     $this->status = 'ok';
     $this->message = 'New Inbox Message sent successfully';
     return $insert_id;
   }


   function editInbox($info, $id){
     $this->db->where('id', $id);
     $this->db->update('tbl_inbox', $info);
     $this->status = 'ok';
     $this->message = 'Inbox Message edited successfully';
   }


   function getInboxInfo($id)
   {
       $this->db->select('tbl_inbox.*');
       $this->db->from('tbl_inbox');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       return $row;
   }


   function deleteInbox($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_inbox');
        $this->status = 'ok';
        $this->message = 'Inbox Message deleted successfully.';
   }

   function getArticleContent($id)
   {
     $this->db->select('tbl_inbox.message');
     $this->db->from('tbl_inbox');
       $this->db->where('tbl_inbox.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if($row){
         return $row->message;
       }
       return "";
   }
}
