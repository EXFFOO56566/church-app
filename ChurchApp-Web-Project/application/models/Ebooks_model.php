<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Ebooks_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function get_total_ebooks(){
      $query = $this->db->select("COUNT(*) as num")->get("tbl_ebooks");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   public function getTrendingebooks($page){
     $this->db->select('tbl_ebooks.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_ebooks');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_ebooks.category');
     $this->db->where('views_count >',0); //update from zero to minimum amount for a media to trend
     $this->db->order_by('views_count','desc');
     if($page!=0){
         $this->db->limit(20,$page * 20);
     }else{
       $this->db->limit(20);
     }
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = $this->get_thumbnail_source($res->thumbnail);
         $res->url = $this->get_media_source($res->url);
       }
       return $result;
    }

   public function update_ebooks_total_views($id){
     //update total views on media
     $this->db->set('views_count', '`views_count`+ 1', false);
     $this->db->where('id' , $id);
     $this->db->update('tbl_ebooks');
     $this->status = 'ok';
   }

   function ebooksListing(){
     $this->db->select('tbl_ebooks.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_ebooks');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_ebooks.category');
       $this->db->order_by('name','ASC');
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = $this->get_thumbnail_source($res->thumbnail);
         $res->url = $this->get_media_source($res->url);
       }
       return $result;
   }

   private function get_thumbnail_source($thumbnail){
       if($this->isValidURL($thumbnail)){
         return $thumbnail;
       }
       return site_url()."uploads/thumbnails/".$thumbnail;
   }

   private function get_media_source($source){
    return site_url()."uploads/pdf/".$source;
   }

   function isValidURL($url){
      return filter_var($url, FILTER_VALIDATE_URL);
  }


   function checkNameExists($name, $id = 0)
   {
       //echo $name . " and ". $group;
       $this->db->select("name");
       $this->db->from("tbl_ebooks");
       $this->db->where("name", $name);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();
       //var_dump($query->result()); die;
       return $query->result();
   }


   function addNewEbook($info)
   {
     if(empty($this->checkNameExists($info['name']))){
       $this->db->trans_start();
       $this->db->insert('tbl_ebooks', $info);
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'Ebook added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Ebook already exists';
     }
   }


   function editEbook($info, $id){
     if(empty($this->checkNameExists($info['name'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_ebooks', $info);
       $this->status = 'ok';
       $this->message = 'Ebook edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Ebook already exists';
     }
   }


   function getEbookInfo($id)
   {
     $this->db->select('tbl_ebooks.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_ebooks');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_ebooks.category');
       $this->db->where('tbl_ebooks.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row) > 0){
         if($this->isValidURL($row->thumbnail)){
           $row->thumbnail = $this->get_thumbnail_source($row->thumbnail);
           $row->_thumbnail = "";
         }else{
            $row->_thumbnail = $this->get_thumbnail_source($row->thumbnail);
            $row->thumbnail = "";
         }
         $row->url = $this->get_media_source($row->url);
       }
       return $row;
   }


   function deleteEbook($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_ebooks');
        $this->status = 'ok';
        $this->message = 'Ebook deleted successfully.';
   }

   public function fetch_ebooks($page = 0){
     $this->db->select('tbl_ebooks.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_ebooks');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_ebooks.category');
       $this->db->order_by('dateAdded','desc');

       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = $this->get_thumbnail_source($res->thumbnail);
         $res->url = $this->get_media_source($res->url);
       }
       return $result;
   }

   public function fetch_categories_ebooks($category,$page = 0,$email="null",$sub=0){
     $this->db->select('tbl_ebooks.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_ebooks');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_ebooks.category');
       $this->db->where('category',$category);
       if($sub!=0){
         $this->db->where('sub_category',$sub);
       }
       $this->db->order_by('dateAdded','desc');

       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = $this->get_thumbnail_source($res->thumbnail);
         $res->url = $this->get_media_source($res->url);
       }
       return $result;
   }

   public function total_categories_ebooks($id,$sub=0){
     $this->db->select("COUNT(*) as num");
     $this->db->where('category',$id);
     if($sub!=0){
       $this->db->where('sub_category',$sub);
     }
     $query = $this->db->get("tbl_ebooks");
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
    }
}
