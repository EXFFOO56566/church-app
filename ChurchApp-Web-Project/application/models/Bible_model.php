<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Bible_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation.';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    function biblesListing(){
        $this->db->select('tbl_bible_versions.*');
        $this->db->from('tbl_bible_versions');

        $this->db->order_by('name','ASC');
        $query = $this->db->get();
        $result = $query->result();
        foreach ($result as $res) {
          $res->source = base_url()."uploads/".$res->source;
        }
        return $result;
    }

    function checkNameExists($name, $id = 0)
    {
        //echo $name . " and ". $group;
        $this->db->select("name");
        $this->db->from("tbl_bible_versions");
        $this->db->where("name", $name);
        if($id != 0){
            $this->db->where("id !=", $id);
        }
        $query = $this->db->get();
        //var_dump($query->result()); die;
        return $query->result();
    }


    function addNewBible($info)
    {
      if(empty($this->checkNameExists($info['name']))){
        $this->db->trans_start();
        $this->db->insert('tbl_bible_versions', $info);
        $this->db->trans_complete();
        $this->status = 'ok';
        $this->message = 'New Bible Version added successfully';
      }else{
        $this->status = 'error';
        $this->message = 'Bible Version name already exists';
      }
    }


    function editBible($info, $id){
      if(empty($this->checkNameExists($info['name'],$id))){
        $this->db->where('id', $id);
        $this->db->update('tbl_bible_versions', $info);
        $this->status = 'ok';
        $this->message = 'Bible Version name edited successfully';
      }else{
        $this->status = 'error';
        $this->message = 'Bible Version name already exists';
      }
    }


    function getBibleInfo($id)
    {
        $this->db->select('tbl_bible_versions.*');
        $this->db->from('tbl_bible_versions');
        $this->db->where('id', $id);
        $query = $this->db->get();
        return $query->row();
    }

    function deleteBible($id){
        $this->db->where('id', $id);
        $this->db->delete('tbl_bible_versions');
         $this->status = 'ok';
         $this->message = 'Bible Version deleted successfully.';
    }
}
