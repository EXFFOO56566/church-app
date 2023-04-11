<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Media_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

   public function getTrendingMedia($page = 0,$email="null", $type="",$version="v2"){
     $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
     $this->db->from('tbl_media');
     $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
     if($type!=""){
       $this->db->where('type',$type);
     }
     if($version=="v1"){
       $this->db->where('video_type',"mp4_video");
     }
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
         $res->cover_photo = $this->get_thumbnail_source($res->cover_photo);
         $res->stream = $this->get_media_source($res->type,$res->video_type,$res->source);
         $res->download = $this->get_media_source($res->type,$res->video_type,$res->source);
         $res->comments_count = $this->get_total_comments($res->id);
         $res->user_liked = $this->checkIfUserLikedMedia($res->id,$email);
       }
       return $result;
    }

    public function fetchRandom($email){
      $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
      $this->db->from('tbl_media');
      $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
      $this->db->order_by('id','DESC');
      $this->db->limit(10);

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

     public function fetch_media($type,$page = 0,$email="null"){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
         $this->db->where('type',$type);

         $this->db->order_by('id','desc');

         if($page!=0){
             $this->db->limit(20,$page * 20);
         }else{
           $this->db->limit(20);
         }

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

     public function fetch_categories_media($category,$page = 0,$email="null",$sub=0,$media_type="all"){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
         if($category!=0){
           $this->db->where('category',$category);
         }

         if($sub!=0){
           $this->db->where('sub_category',$sub);
         }

         if($media_type!="all"){
           $this->db->where('type',$media_type);
         }

         $this->db->order_by('dateInserted','desc');

         if($page!=0){
             $this->db->limit(20,$page * 20);
         }else{
           $this->db->limit(20);
         }

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

     function addNewMedia($info){
       $this->db->trans_start();
       $info['dateInserted'] = date('Y-m-d H:i:s');
       $this->db->insert('tbl_media', $info);
       $this->status = 'ok';
       $this->message = $info['title'].' Uploaded successfully';
       $insert_id = $this->db->insert_id();
       $this->db->trans_complete();
       return $insert_id;
     }

     function getMediaInfo($id){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
       $this->db->where('tbl_media.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       return $row;
     }

     function fetchPlayableMedia($id){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
       $this->db->where('tbl_media.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row)>0){
         $row->cover_photo = $this->get_thumbnail_source($row->cover_photo);
         $row->stream = $this->get_media_source($row->type,$row->video_type,$row->source);
         $row->download = $this->get_media_source($row->type,$row->video_type,$row->source);
         $row->comments_count = $this->get_total_comments($row->id);
       }
       return $row;
     }

     function editMedia($info, $id){
       $this->db->where('id', $id);
       $this->db->update('tbl_media', $info);
       $this->status = 'ok';
       $this->message = $info['title'].' Updated successfully';
     }

     function deleteMedia($id){
         $this->db->where('id', $id);
         $this->db->delete('tbl_media');
     }

     public function get_total_comments($id){
       $query = $this->db->select("COUNT(*) as num")->where('media_id',$id)->where('deleted',1)->get("tbl_comments");
       $result = $query->row();
       if(isset($result)) return $result->num;
       return 0;
      }

     public function likeunlikemedia($media,$email,$action="like"){
       if($action=="unlike"){
         $this->db->where('media_id', $media);
         $this->db->where('email', $email);
         $this->db->delete('tbl_media_likes');

         //update total likes on media
         $this->db->set('likes_count', '`likes_count`- 1', false);
         $this->db->where('id' , $media);
         $this->db->update('tbl_media');
         $this->status = "ok";
         $this->message = 'media unliked successfully';
       }else{
         $data = [':media_id' => $media,':email' => $email ,':date' => time()];
         $sql = "INSERT INTO tbl_media_likes (media_id, email,date) VALUES (:media_id, :email, :date)";
         $stmt= $this->db->conn_id->prepare($sql);
         $stmt->execute($data);

         //update total likes on media
         $this->db->set('likes_count', '`likes_count`+ 1', false);
         $this->db->where('id' , $media);
         $this->db->update('tbl_media');
         $this->status = "ok";
         $this->message = 'media liked successfully';
       }
     }

    public function checkIfUserLikedMedia($media,$email){
        $this->db->select('tbl_media_likes.*');
        $this->db->from('tbl_media_likes');
        $this->db->where('media_id',$media);
        $this->db->where('email',$email);
        $query = $this->db->get();
        return count((array)$query->result())>0?true:false;
    }

    public function update_media_total_views($media){
      //update total views on media
      $this->db->set('views_count', '`views_count`+ 1', false);
      $this->db->where('id' , $media);
      $this->db->update('tbl_media');
      $this->status = 'ok';
    }

    public function get_total_media($type,$version="v1"){
      $this->db->select("COUNT(*) as num");
      $this->db->where('type',$type);
      $query = $this->db->get("tbl_media");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }

    public function total_categories_media($id,$sub=0,$version="v1"){
      $this->db->select("COUNT(*) as num");
      if($id!=0){
           $this->db->where('category',$id);
         }


      if($sub!=0){
        $this->db->where('sub_category',$sub);
      }
      if($version=="v1"){
        $this->db->where('video_type',"mp4_video");
      }
      $query = $this->db->get("tbl_media");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
     }

     public function total_trending_media($version="v1"){
       $this->db->select("COUNT(*) as num");
       $this->db->where('views_count > ',0);
       if($version=="v1"){
         $this->db->where('video_type',"mp4_video");
       }
       $query = $this->db->get("tbl_media");
       $result = $query->row();
       if(isset($result)) return $result->num;
       return 0;
      }

     function getMediaTotalViews($id){
       $this->db->select('tbl_media.views_count');
       $this->db->from('tbl_media');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       return $row->views_count;
     }

     function getMediaTotalLikes($id){
       $this->db->select('tbl_media.likes_count');
       $this->db->from('tbl_media');
       $this->db->where('id', $id);
       $query = $this->db->get();
       $row = $query->row();
       return $row->likes_count;
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

     /**
     * function to fetch all media files
     * used for test purposes
     **/
     public function get_all_medias(){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
         $query = $this->db->get();
         $result = $query->result();
         return $result;
     }

     public function fetch_user_purchases($page = 0,$email="null"){
       $this->db->select('tbl_media.*,tbl_categories.id as category_id,tbl_categories.name as category');
       $this->db->from('tbl_media');
       $this->db->join('tbl_categories','tbl_categories.id=tbl_media.category');
       $this->db->join('tbl_media_purchases','tbl_media_purchases.media_id=tbl_media.id');
         $this->db->where('tbl_media_purchases.email',$email);
         $this->db->order_by('dateInserted','desc');

         if($page!=0){
             $this->db->limit(20,$page * 20);
         }else{
           $this->db->limit(20);
         }

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

     public function fetch_user_purchases_id($email="null"){
       $this->db->select('tbl_media_purchases.media_id');
       $this->db->from('tbl_media_purchases');
       $this->db->where('tbl_media_purchases.email',$email);
       $query = $this->db->get();
       return $query->result();
     }
}
