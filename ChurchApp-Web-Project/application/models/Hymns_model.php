<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Hymns_model extends CI_Model{
    public $status = 'error';
    public $message = 'Something went wrong';
    public $data = [];
    public $date = "";

    function __construct(){
       parent::__construct();
	  }

    function getHymn($id=0){
        $this->db->select('tbl_hymns.*');
        $this->db->from('tbl_hymns');
        $this->db->where('id', $id);
        $query = $this->db->get();
        return $query->row();
    }


   function adminHymnsListing($columnName,$columnSortOrder,$searchValue,$start, $length){
     $this->db->select('tbl_hymns.*');
     $this->db->from('tbl_hymns');
     if($searchValue!=""){
         $this->db->like('title', $searchValue);
         $this->db->or_like('content', $searchValue);
     }
     if($columnName!=""){
        $this->db->order_by($columnName, $columnSortOrder);
     }else{
       $this->db->order_by("id", "DESC");
     }
     $this->db->limit($length,$start);
     $query = $this->db->get();
     return $query->result();
   }

   public function get_total_hymns($searchValue=""){
     if($searchValue==""){
       $query = $this->db->select("COUNT(*) as num")->get("tbl_hymns");
     }else{
       $this->db->select("COUNT(*) as num");
       $this->db->from('tbl_hymns');
       $this->db->like('title', $searchValue);
       $this->db->or_like('content', $searchValue);
       $query = $this->db->get();
     }
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

   function checkHymnExists($title, $id = 0)
   {
       $this->db->select("title");
       $this->db->from("tbl_hymns");
       $this->db->where("title", $title);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();
       return $query->result();
   }


   function addNewHymn($info)
   {
     $insert_id = 0;
     if(empty($this->checkHymnExists($info['title']))){
       $this->db->trans_start();
       $this->db->insert('tbl_hymns', $info);
       $insert_id = $this->db->insert_id();
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'Hymn added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Hymn already added with this title '.$info['title'];
     }
     return $insert_id;
   }


   function editHymn($info, $id){
     if(empty($this->checkHymnExists($info['title'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_hymns', $info);
       $this->status = 'ok';
       $this->message = 'Hymn edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Title for this hymn already exists for another';
     }
   }


   function getHymnInfo($id)
   {
     $this->db->select('tbl_hymns.*');
     $this->db->from('tbl_hymns');
       $this->db->where('tbl_hymns.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row) > 0 && $row->thumbnail!=""){
         $row->thumbnail = base_url()."uploads/thumbnails/".$row->thumbnail;
       }
       return $row;
   }


   function deleteHymn($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_hymns');
       $this->status = 'ok';
       $this->message = 'Devotional deleted successfully.';
   }

   public function fetch_hymns($page = 0,$query=""){
     $this->db->select('tbl_hymns.*');
     $this->db->from('tbl_hymns');
     if($query!=""){
         $this->db->like('title', $query);
         $this->db->or_like('content', $query);
     }
     $this->db->order_by('id','DESC');

       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = base_url()."uploads/thumbnails/".$res->thumbnail;
       }
       return $result;
   }


}
