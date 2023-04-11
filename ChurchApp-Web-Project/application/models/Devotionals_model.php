<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Devotionals_model extends CI_Model{
    public $status = 'error';
    public $message = 'Something went wrong';
    public $data = [];
    public $date = "";

    function __construct(){
       parent::__construct();
	  }

    function getDevotional($date=""){
        $this->db->select('tbl_devotionals.*');
        $this->db->from('tbl_devotionals');
        $this->db->where('date', $date);
        $query = $this->db->get();
        return $query->row();
    }

    public function update_total_views($id){
      //update total views on media
      $this->db->set('views_count', '`views_count`+ 1', false);
      $this->db->where('id' , $id);
      $this->db->update('tbl_devotionals');
      $this->status = 'ok';
    }

    function getTotalViews($id){
      $this->db->select('tbl_devotionals.views_count');
      $this->db->from('tbl_devotionals');
      $this->db->where('id', $id);
      $query = $this->db->get();
      $row = $query->row();
      return $row->views_count;
    }


    function getArticleData($id)
    {
      $this->db->select('tbl_devotionals.*,interests.id as interest_id,interests.name as interest');
      $this->db->from('tbl_devotionals');
      $this->db->join('interests','interests.id=tbl_devotionals.interest');
        $this->db->where('tbl_devotionals.id', $id);
        $query = $this->db->get();
        $row = $query->row();
        if(count((array)$row)>0){
          $row->timeStamp = strtotime($row->date);
          $row->comments_count = $this->get_total_comments($row->id);
          $row->likes_count = $this->get_total_likes($row->id);
          $row->thumbnail = $this->get_media_source($row->thumbnail);
          $row->timeStamp = strtotime($row->date);
          $row->date = date("D M j G:i:s T Y", $row->timeStamp);
          $row->title = preg_replace('/\s+/S', " ", $row->title);
          if($row->feed_type == "article"){
            $row->content = "";
          }
          $row->video_source = $this->get_video_source($row->video_source,$row->video_type);
        }
        //echo $row->source; die;
        return $row;
    }


        function getArticleContent($id)
        {
          $this->db->select('tbl_devotionals.content');
          $this->db->from('tbl_devotionals');
            $this->db->where('tbl_devotionals.id', $id);
            $query = $this->db->get();
            $row = $query->row();
            if($row){
              return $row->content;
            }
            return "";
        }

   function feedsListing($data = []){

     $this->db->select('tbl_devotionals.*,interests.id as interest_id,interests.name as interest');
     $this->db->from('tbl_devotionals');
     $this->db->join('interests','interests.id=tbl_devotionals.interest');

     if(isset($data->interests)){
        $this->db->where('tbl_devotionals.interest ', $data->interests);
     }

     if(isset($data->date)){
       $this->db->where('tbl_devotionals.dateInserted < ', $data->date);
     }
      $this->db->order_by('date', 'desc');
      if(isset($data->offset)){
        $this->db->limit(20,$data->offset + 1);
      }else{
        $this->db->limit(20,0);
      }
      $query = $this->db->get();


       //var_dump($query); die;
       $result = $query->result();
       foreach ($result as $res) {
         $res->thumbnail = $this->get_media_source($res->thumbnail);
         $res->timeStamp = strtotime($res->date);
         $res->comments_count = $this->get_total_comments($res->id);
         $res->likes_count = $this->get_total_likes($res->id);
         $res->date = date("D M j G:i:s T Y", $res->timeStamp);
         $res->title = preg_replace('/\s+/S', " ", $res->title);
         if($res->feed_type == "article"){
           $res->content = $this->character_limiter(strip_tags($res->content),200);
         }
         $res->video_source = $this->get_video_source($res->video_source,$res->video_type);
       }

       $this->data = $result;
       if(count((array)$result)>0){
         $this->date = $result[0]->dateInserted;
       }
   }

   public function get_total_comments($id){
     $query = $this->db->select("COUNT(*) as num")->where('post_id',$id)->where('deleted',1)->get("tbl_comments");
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

  public function get_total_likes($id){
    $query = $this->db->select("COUNT(*) as num")->where('post_id',$id)->get("tbl_likes");
    $result = $query->row();
    if(isset($result)) return $result->num;
    return 0;
 }


   function trendingFeedsListing($data = []){

     $this->db->select('tbl_devotionals.*,interests.id as interest_id,interests.name as interest');
     $this->db->from('tbl_devotionals');
     $this->db->join('interests','interests.id=tbl_devotionals.interest');

     if(isset($data->interests)){
        $this->db->where('tbl_devotionals.interest ', $data->interests);
     }

     if(isset($data->date)){
       $this->db->where('tbl_devotionals.dateInserted < ', $data->date);
     }
     $this->db->where('views_count >',0); //update from zero to minimum amount for a media to trend
     $this->db->order_by('views_count','desc');
      if(isset($data->offset)){
        $this->db->limit(20,$data->offset + 1);
      }else{
        $this->db->limit(20,0);
      }
      $query = $this->db->get();


       //var_dump($query); die;
       $result = $query->result();
       foreach ($result as $res) {
         $res->comments_count = $this->get_total_comments($res->id);
         $res->likes_count = $this->get_total_likes($res->id);
         $res->thumbnail = $this->get_media_source($res->thumbnail);
         $res->timeStamp = strtotime($res->date);
         $res->date = date("D M j G:i:s T Y", $res->timeStamp);
         $res->title = preg_replace('/\s+/S', " ", $res->title);
         if($res->feed_type == "article"){
           $res->content = $this->character_limiter(strip_tags($res->content),200);
         }
         $res->video_source = $this->get_video_source($res->video_source,$res->video_type);
       }

       $this->data = $result;
       if(count((array)$result)>0){
         $this->date = $result[0]->dateInserted;
       }
   }


function character_limiter($str, $n = 500, $end_char = '&#8230;')
{
    if (strlen($str) < $n)
    {
        return $str;
    }

    $str = preg_replace("/\s+/", ' ', str_replace(array("\r\n", "\r", "\n"), ' ', $str));

    if (strlen($str) <= $n)
    {
        return $str;
    }

    $out = "";
    foreach (explode(' ', trim($str)) as $val)
    {
        $out .= $val.' ';

        if (strlen($out) >= $n)
        {
            $out = trim($out);
            return (strlen($out) == strlen($str)) ? $out : $out.$end_char;
        }
    }
 }


   function adminDevotionalsListing($columnName,$columnSortOrder,$searchValue,$start, $length){
     $this->db->select('tbl_devotionals.*');
     $this->db->from('tbl_devotionals');
     if($searchValue!=""){
         $this->db->like('title', $searchValue);
         $this->db->or_like('content', $searchValue);
     }
     if($columnName!=""){
        $this->db->order_by($columnName, $columnSortOrder);
     }else{
       $this->db->order_by("date", "DESC");
     }
     $this->db->limit($length,$start);
     $query = $this->db->get();
     return $query->result();
   }

   public function get_total_devotionals($searchValue=""){
     if($searchValue==""){
       $query = $this->db->select("COUNT(*) as num")->get("tbl_devotionals");
     }else{
       $this->db->select("COUNT(*) as num");
       $this->db->from('tbl_devotionals');
       $this->db->join('tbl_rss_urls','tbl_rss_urls.id = tbl_devotionals.channel');
       $this->db->like('title', $searchValue);
       $this->db->or_like('content', $searchValue);
       $query = $this->db->get();
     }
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

   function checkDevotionalExists($date, $id = 0)
   {
       $this->db->select("title");
       $this->db->from("tbl_devotionals");
       $this->db->where("date", $date);
       if($id != 0){
           $this->db->where("id !=", $id);
       }
       $query = $this->db->get();

       return $query->result();
   }


   function addNewDevotional($info)
   {
     $insert_id = 0;
     if(empty($this->checkDevotionalExists($info['date']))){
       $this->db->trans_start();
       $this->db->insert('tbl_devotionals', $info);
       $insert_id = $this->db->insert_id();
       $this->db->trans_complete();
       $this->status = 'ok';
       $this->message = 'Devotional added successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Devotional already added for this date '.$info['date'];
     }
     return $insert_id;
   }


   function editDevotional($info, $id){
     if(empty($this->checkDevotionalExists($info['date'],$id))){
       $this->db->where('id', $id);
       $this->db->update('tbl_devotionals', $info);
       $this->status = 'ok';
       $this->message = 'Devotional edited successfully';
     }else{
       $this->status = 'error';
       $this->message = 'Date for this devotional already exists for another';
     }
   }


   function getDevotionalInfo($id)
   {
     $this->db->select('tbl_devotionals.*');
     $this->db->from('tbl_devotionals');
       $this->db->where('tbl_devotionals.id', $id);
       $query = $this->db->get();
       $row = $query->row();
       if(count((array)$row) > 0 && $row->thumbnail!=""){
         $row->thumbnail = base_url()."uploads/thumbnails/".$row->thumbnail;
       }
       return $row;
   }


   function deleteDevotional($id){
       $this->db->where('id', $id);
       $this->db->delete('tbl_devotionals');
       $this->status = 'ok';
       $this->message = 'Devotional deleted successfully.';
   }


  function delete_old_articles()
  {
    $date = date("Y-m-d", strtotime('-7 day'));
    $this->db->where('dateInserted < ', $date);
    $this->db->delete('tbl_devotionals');
  }

  private function get_video_source($source,$type){
      if($source==""){
        return "";
      }
      if($type!="mp4_video"){
        return $source;
      }
      if($this->isValidURL($source)){
        return $source;
      }
      return site_url()."uploads/videos/".$source;
  }

  private function get_media_source($source){
      if($this->isValidURL($source)){
        return $source;
      }
      return site_url()."uploads/thumbnails/".$source;
  }

  function isValidURL($url){
     return filter_var($url, FILTER_VALIDATE_URL);
 }
}
