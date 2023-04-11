<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Branches_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function fetch_branches($page = 0){
      $this->db->select('tbl_branches.*');
      $this->db->from('tbl_branches');

        $this->db->order_by('name','ASC');

        if($page!=0){
            $this->db->limit(20,$page * 20);
        }else{
          $this->db->limit(20);
        }
        $query = $this->db->get();
        $result = $query->result();
        return $result;
    }

  
    public function get_total_branches(){
      $query = $this->db->select("COUNT(*) as num")->get("tbl_branches");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

   function branchesListing(){
       $this->db->select('tbl_branches.*');
       $this->db->from('tbl_branches');

       $this->db->order_by('name','ASC');
       $query = $this->db->get();
       return $query->result();
       return $result;
   }

   function checkNameExists($name, $id = 0)
   {
       //echo $name . " and ". $group;
       $this->db->select("name");
       $this->db->from("tbl_branches");
       $this->db->where("name", $name);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();
       //var_dump($query->result()); die;
       return $query->result();
   }


   function addNewBranch($info)
   {
     if(empty($this->checkNameExists($info['name']))){
       $this->db->trans_start();
       $this->db->insert('tbl_branches', $info);
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'New Church Branch added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Church Branch already exists';
     }
   }


   function editBranch($info, $id){
     if(empty($this->checkNameExists($info['name'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_branches', $info);
       $this->status = 'ok';
       $this->message = 'Church Branch edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Church Branch already exists';
     }
   }


   function getBranchInfo($id)
   {
       $this->db->select('tbl_branches.*');
       $this->db->from('tbl_branches');
       $this->db->where('id', $id);
       $query = $this->db->get();
       return $query->row();
   }

   function deleteBranch($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_branches');
        $this->status = 'ok';
        $this->message = 'Church branch deleted successfully.';
   }
}
