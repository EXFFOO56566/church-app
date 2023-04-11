<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class : Install
 * Class to install database tables
 */
class Install extends CI_Controller
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->load->model('install_model');
    }


    public function index(){
      $this->install_model->create_users_table();
      $this->install_model->create_settings_table();
      $this->install_model->create_android_users_table();
      $this->install_model->create_fcm_token_table();
      $this->install_model->create_media_table();
      $this->install_model->create_verification_table();
      $this->install_model->create_comments_table();
      $this->install_model->create_reports_table();
      $this->install_model->create_media_likes_table();
      $this->install_model->create_categories_table();
      $this->install_model->create_sub_categories_table();
      $this->install_model->create_livestream_table();
      $this->install_model->create_devotionals_table();
      $this->install_model->create_events_table();
      $this->install_model->create_inbox_table();
      $this->install_model->create_radio_table();
      $this->install_model->create_coins_table();
      $this->install_model->create_coins_purchases_table();
      $this->install_model->create_media_purchases_table();
    }
}

?>
