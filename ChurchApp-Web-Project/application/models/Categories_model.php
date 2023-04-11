<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Categories_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function get_total_category(){
      $query = $this->db->select("COUNT(*) as num")->get("tbl_categories");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   function categoriesListing(){
       $this->db->select('tbl_categories.*');
       $this->db->from('tbl_categories');

       $this->db->order_by('name','ASC');
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = base_url()."uploads/thumbnails/".$res->thumbnail;
         $res->media_count = $this->get_total_media($res->id);
       }
       return $result;
   }

   public function get_total_media($id){
     $query = $this->db->select("COUNT(*) as num")->where('category',$id)->get("tbl_media");
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
    }


   function checkNameExists($name, $id = 0)
   {
       //echo $name . " and ". $group;
       $this->db->select("name");
       $this->db->from("tbl_categories");
       $this->db->where("name", $name);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();
       //var_dump($query->result()); die;
       return $query->result();
   }


   function addNewCategory($info)
   {
     if(empty($this->checkNameExists($info['name']))){
       $this->db->trans_start();
       $this->db->insert('tbl_categories', $info);
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'Category added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Category already exists';
     }
   }


   function editCategory($info, $id){
     if(empty($this->checkNameExists($info['name'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_categories', $info);
       $this->status = 'ok';
       $this->message = 'Category edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Category already exists';
     }
   }


   function getCategoryInfo($id)
   {
       $this->db->select('tbl_categories.*');
       $this->db->from('tbl_categories');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row) > 0){
         $row->thumbnail = base_url()."uploads/thumbnails/".$row->thumbnail;
       }
       return $row;
   }


   function deleteCategory($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_categories');
        $this->status = 'ok';
        $this->message = 'Category deleted successfully.';
   }

   //sub categories model
   function subcategoriesListing($category=0){
       $this->db->select('tbl_sub_categories.*,tbl_categories.name as category');
       $this->db->from('tbl_sub_categories');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_sub_categories.category_id');
       if($category!=0){
         $this->db->where("tbl_sub_categories.category_id",$category);
       }

       $this->db->order_by('tbl_sub_categories.id','ASC');
       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res) {
         $res->media_count = $this->get_total_subcategory_media($res->id);
       }
       //var_dump($result); die;
       return $result;
   }

   public function get_total_subcategory_media($id){
     $query = $this->db->select("COUNT(*) as num")->where('sub_category',$id)->get("tbl_media");
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
    }


   function checkSubCategoryNameExists($name,$category, $id = 0)
   {
       $this->db->select("name");
       $this->db->from("tbl_sub_categories");
       $this->db->where("name", $name);
       $this->db->where("category_id",$category);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();
       return $query->result();
   }


   function addNewSubCategory($info)
   {
     if(empty($this->checkSubCategoryNameExists($info['name'],$info['category_id']))){
       $this->db->trans_start();
       $this->db->insert('tbl_sub_categories', $info);
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'SubCategory added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'SubCategory already exists';
     }
   }


   function editSubCategory($info, $id){
     if(empty($this->checkSubCategoryNameExists($info['name'],$info['category_id'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_sub_categories', $info);
       $this->status = 'ok';
       $this->message = 'SubCategory edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'SubCategory already exists';
     }
   }


   function getSubCategoryInfo($id)
   {
       $this->db->select('tbl_sub_categories.*');
       $this->db->from('tbl_sub_categories');
       $this->db->where('id', $id);
       $query = $this->db->get();
       return $query->row();
   }


   function deleteSubCategory($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_sub_categories');
        $this->status = 'ok';
        $this->message = 'SubCategory deleted successfully.';
   }
}
