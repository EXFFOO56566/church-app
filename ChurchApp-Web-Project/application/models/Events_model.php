<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Events_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }


    public function get_total_events($date=""){
      $this->db->select("COUNT(*) as num");
      $this->db->from('tbl_events');
      $this->db->where('date',$date);
      $query = $this->db->get();
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   function fetchEvents($date=""){
       $this->db->select('tbl_events.*');
       $this->db->from('tbl_events');
       $this->db->where('date',$date);
       $this->db->order_by('date','desc');
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = base_url()."uploads/thumbnails/events/".$res->thumbnail;
       }
       return $result;
   }


   function eventsListing(){
     $this->db->select('tbl_events.*');
     $this->db->from('tbl_events');
     $this->db->order_by('date','desc');
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = base_url()."uploads/thumbnails/events/".$res->thumbnail;
       }
       return $result;
   }

   function getEventsData($id)
   {
     $this->db->select('tbl_events.*');
     $this->db->from('tbl_events');
     $this->db->where('id', $id);
     $query = $this->db->get();
     $row = $query->row();
     if(count((array)$row) > 0){
       $row->thumbnail = base_url()."uploads/thumbnails/events/".$row->thumbnail;
       //$row->details = "";
     }
       //echo $row->source; die;
       return $row;
   }


   function addNewEvent($info)
   {
     $insert_id = 0;
     $this->db->trans_start();
     $this->db->insert('tbl_events', $info);
     $insert_id = $this->db->insert_id();
     $this->db->trans_complete();
     $this->status = 'ok';
     $this->message = 'Event added successfully';
     return $insert_id;
   }


   function editEvent($info, $id){
     $this->db->where('id', $id);
     $this->db->update('tbl_events', $info);
     $this->status = 'ok';
     $this->message = 'Event edited successfully';
   }


   function getEventInfo($id)
   {
       $this->db->select('tbl_events.*');
       $this->db->from('tbl_events');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row) > 0){
         $row->thumbnail = base_url()."uploads/thumbnails/events/".$row->thumbnail;
       }
       return $row;
   }


   function deleteEvent($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_events');
        $this->status = 'ok';
        $this->message = 'Event deleted successfully.';
   }

   function getArticleContent($id)
   {
     $this->db->select('tbl_events.details');
     $this->db->from('tbl_events');
       $this->db->where('tbl_events.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if($row){
         return $row->details;
       }
       return "";
   }
}
