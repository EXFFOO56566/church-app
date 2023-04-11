<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Music_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

      function audioListing($columnName,$columnSortOrder,$searchValue,$start, $length){
        $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
        $this->db->from('tbl_media');
        $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
        $this->db->where('type','music');
        if($searchValue!=""){
            $this->db->like('title', $searchValue);
            $this->db->or_like('description', $searchValue);
        }
        if($columnName!=""){
           $this->db->order_by($columnName, $columnSortOrder);
        }
        $this->db->limit($length,$start);

        $query = $this->db->get();
        $result = $query->result();
        foreach ($result as $res) {
          $res->source = $this->get_media_source($res->source);
          $res->comments_count = $this->get_total_comments($res->id);
          $res->likes_count = 0;
        }
        return $result;
      }

      public function get_total_audios($searchValue=""){
        if($searchValue==""){
          $query = $this->db->select("COUNT(*) as num")->where('type','music')->get("tbl_media");
        }else{
          $this->db->select("COUNT(*) as num");
          $this->db->from('tbl_media');
          $this->db->where('tbl_media.type','music');
          $this->db->like('title', $searchValue);
          $this->db->or_like('description', $searchValue);
          $query = $this->db->get();
        }
        $result = $query->row();
        if(isset($result)) return $result->num;
        return 0;
     }

     function addNewAudio($info)
     {
       $this->db->trans_start();
       $info['dateInserted'] = date('Y-m-d H:i:s');
       $this->db->insert('tbl_media', $info);
       $this->status = 'ok';
       $this->message = $info['title'].' Uploaded successfully';
       $insert_id = $this->db->insert_id();
       $this->db->trans_complete();
       return $insert_id;
     }

     function getAudioInfo($id)
     {
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
         $this->db->where('tbl_media.id', $id);
         $query = $this->db->get();
         $row = $query->row();
         if(count((array)$row)>0){
           $row->thumbnail = $this->get_thumbnail_source($row->cover_photo);
           $row->audio = $this->get_media_source($row->source);
           $row->comments_count = $this->get_total_comments($row->id);
           $row->likes_count = 0;
         }
         return $row;
     }

     function editAudioData($info, $id){
       $this->db->where('id', $id);
       $this->db->update('tbl_media', $info);
       $this->status = 'ok';
       $this->message = 'Music Data edited successfully';
     }

     function deleteAudio($id){
         $this->db->where('id', $id);
         $this->db->delete('tbl_media');
          $this->status = 'ok';
          $this->message = 'Music Data deleted successfully.';
     }

     public function get_total_comments($id){
       $query = $this->db->select("COUNT(*) as num")->where('media_id',$id)->where('deleted',1)->get("tbl_comments");
       $result = $query->row();
       if(isset($result)) return $result->num;
       return 0;
    }

    private function get_thumbnail_source($source){
        if($this->isValidURL($source)){
          return $source;
        }
        return site_url()."uploads/thumbnails/".$source;
    }

    private function get_media_source($source){
        if($this->isValidURL($source)){
          return $source;
        }
        return site_url()."uploads/music/".$source;
    }

    function isValidURL($url){
       return filter_var($url, FILTER_VALIDATE_URL);
   }
}
