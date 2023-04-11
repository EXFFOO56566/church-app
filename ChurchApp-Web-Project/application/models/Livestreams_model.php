<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Livestreams_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Error processing requested operation';


  function getLiveStreams(){
      $this->db->select('tbl_streaming.*');
      $this->db->from('tbl_streaming');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row();
  }


  function updateLiveStreams($data){
      $this->db->where('id', 100);
      $this->db->update('tbl_streaming', $data);
      $this->status = 'ok';
      $this->message = $data['title'].' status updated successfully';
  }
}
