<?php
defined('BASEPATH') OR exit('No direct script access allowed');
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Search_model extends CI_Model{
    public $status = "error";
    public $msg = "Error processing requested operation";

    public function searchListing($query,$offset,$email){
      //var_dump($this->do_custom_relevanssi_stuff($query)); die;
      $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
      $this->db->from('tbl_media');
      $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');

      $this->db->where("(`title` LIKE '%$query%'");
      $this->db->or_where("`description` LIKE '%$query%')");
      $this->db->order_by('dateInserted','desc');
      $this->db->limit(20, $offset);

        $query = $this->db->get();
        $result = $query->result();
        foreach ($result as $res) {
          $res->cover_photo = $this->get_thumbnail_source($res->cover_photo);
          $res->stream = $this->get_media_source($res->type,$res->video_type,$res->source);
          $res->download = $this->get_media_source($res->type,$res->video_type,$res->source);
          $res->comments_count = $this->get_total_comments($res->id);
          $res->user_liked = $this->checkIfUserLikedMedia($res->id,$email);
        }
        return $result;
     }


   public function get_total_comments($id){
     $query = $this->db->select("COUNT(*) as num")->where('media_id',$id)->where('deleted',1)->get("tbl_comments");
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
    }

   function getMediaTotalLikes($id){
     $this->db->select('tbl_media.*');
     $this->db->from('tbl_media');
     $this->db->where('id', $id);
     $query = $this->db->get();
     $row = $query->row();
     return $row->likes_count;
   }

   function getMediaTotalViews($id){
     $this->db->select('tbl_media.views_count');
     $this->db->from('tbl_media');
     $this->db->where('id', $id);
     $query = $this->db->get();
     $row = $query->row();
     return $row->views_count;
   }

  public function checkIfUserLikedMedia($media,$email){
      $this->db->select('tbl_media_likes.*');
      $this->db->from('tbl_media_likes');
      $this->db->where('media_id',$media);
      $this->db->where('email',$email);
      $query = $this->db->get();
      return count((array)$query->result())>0?true:false;
  }

  private function get_thumbnail_source($source){
      if($this->isValidURL($source)){
        return $source;
      }
      return site_url()."uploads/thumbnails/".$source;
  }

  private function get_media_source($type,$video_type,$source){
      if($this->isValidURL($source)){
        return $source;
      }
      if($type=="audio"){
        return site_url()."uploads/audios/".$source;
      }else{
        if($video_type == "mp4_video"){
          return site_url()."uploads/videos/".$source;
        }
        return $source;
      }
  }

  function isValidURL($url){
     return filter_var($url, FILTER_VALIDATE_URL);
 }

}
