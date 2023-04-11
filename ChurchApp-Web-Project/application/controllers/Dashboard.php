<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';
class Dashboard extends BaseController {

  public function __construct()
     {
        // Ensure you run parent constructor
        parent::__construct();
        $this->isLoggedIn();
        $this->load->model('media_model');
        $this->load->model('account_model');
        $this->load->model('user_model');
        $this->load->model('comments_model');
     }

    public function index(){
      $data['audios'] = $this->media_model->get_total_media("audio");
      $data['videos'] = $this->media_model->get_total_media("video");
      $data['users'] = $this->account_model->get_total_users();
      $data['admin'] = $this->user_model->get_total_admin();
      $data['comments'] = $this->comments_model->get_total_user_comments();
      $data['reports'] = $this->comments_model->get_total_reports();
      $this->load->template('dashboard', $data); // this will load the view file
    }
}
