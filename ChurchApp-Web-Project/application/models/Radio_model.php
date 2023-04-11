<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Radio_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Error processing requested operation';


  function getRadio(){
      $this->db->select('tbl_radio.*');
      $this->db->from('tbl_radio');
      $this->db->where('id', 100);
      $query = $this->db->get();
      return $query->row();
  }


  function updateRadio($data){
      $this->db->where('id', 100);
      $this->db->update('tbl_radio', $data);
      $this->status = 'ok';
      $this->message = $data['title'].' status updated successfully';
  }
}
