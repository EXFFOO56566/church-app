<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Settings_model extends CI_Model{

  public $status = 'error';
  public $message = 'Something went wrong';

  function __construct(){
     parent::__construct();
  }

  function getWebsiteUrl(){
      $this->db->select('settings.website_url');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->website_url;
  }

  function getHomePageImage($image){
      $this->db->select('settings.*');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      switch($image){
        case "image_one": default:
           return $query->row()->image_one;
       case "image_two":
          return $query->row()->image_two;
      case "image_three":
         return $query->row()->image_three;
       case "image_four":
          return $query->row()->image_four;
      case "image_five":
         return $query->row()->image_five;
       case "image_six":
          return $query->row()->image_six;
      case "image_seven":
         return $query->row()->image_seven;
     case "image_eight":
        return $query->row()->image_eight;
      }
  }

  function getAdvertsInterval(){
      $this->db->select('settings.ads_interval');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->ads_interval;
  }

  function getFacebookPage(){
      $this->db->select('settings.facebook_page');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->facebook_page;
  }

  function getYoutubePage(){
      $this->db->select('settings.youtube_page');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->youtube_page;
  }

  function getTwitterPage(){
      $this->db->select('settings.twitter_page');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->twitter_page;
  }

  function getInstagramPage(){
      $this->db->select('settings.instagram_page');
      $this->db->from('settings');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row()->instagram_page;
  }


    function getFcmServerKey(){
        $this->db->select('settings.fcm_server_key');
        $this->db->from('settings');
        $this->db->where('id', 100);
        $query = $this->db->get();
        return $query->row()->fcm_server_key;
    }

    function getSettings(){
        $this->db->select('settings.*');
        $this->db->from('settings');
        $this->db->where('id', 100);
        $query = $this->db->get();
        return $query->row();
    }


    function updateSettings($data){
        $this->db->where('id', 100);
        $this->db->update('settings', $data);
        $this->status = 'ok';
        $this->message = 'Settings updated successfully';
    }
}

?>
