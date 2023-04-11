<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

/**
 * Class : Settings (SettingsController)
 * Settings Class to control all app settings related operations
 */
class Settings extends BaseController
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->isLoggedIn();
    }


    public function index()
    {
      $this->load->model('settings_model');
      $data['settings'] = $this->settings_model->getSettings();
      $this->load->template('settings', $data); // this will load the view file
    }

    public function searchIndex(){
      $this->load->model('search_model');
      $this->search_model->checkIndexExists();
      $data['status'] = $this->search_model->msg==true?"Index Already Created.":"";
      $this->load->template('searchindex', $data);
    }

    function updateSettings()
    {
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->load->model('settings_model');

            $data = array('fcm_server_key'=>$this->input->post('fcm_server_key')
            ,'ads_interval'=>$this->input->post('ads_interval')
            ,'facebook_page'=>$this->input->post('facebook_page')
            ,'youtube_page'=>$this->input->post('youtube_page')
            ,'twitter_page'=>$this->input->post('twitter_page')
            ,'website_url'=>$this->input->post('website_url')
            ,'image_one'=>$this->input->post('image_one')
            ,'image_two'=>$this->input->post('image_two')
            ,'image_three'=>$this->input->post('image_three')
            ,'image_four'=>$this->input->post('image_four')
            ,'image_five'=>$this->input->post('image_five')
            ,'image_six'=>$this->input->post('image_six')
            ,'image_seven'=>$this->input->post('image_seven')
            ,'image_eight'=>$this->input->post('image_eight')
            ,'instagram_page'=>$this->input->post('instagram_page')
            ,'mail_username'=>$this->input->post('mail_username')
            ,'mail_password'=>$this->input->post('mail_password'),'mail_smtp_host'=>$this->input->post('mail_smtp_host')
            ,'mail_protocol'=>$this->input->post('mail_protocol'),'mail_port'=>$this->input->post('mail_port'));
            $this->settings_model->updateSettings($data);
            if($this->settings_model->status == "ok")
            {
                $this->session->set_flashdata('success', $this->settings_model->message);
            }
            else
            {
                $this->session->set_flashdata('error', $this->settings_model->message);
            }

            redirect('settings');

    }

    //create new elastic search index
    		function createElasticIndex(){
            $this->load->model('search_model');
            $this->search_model->createIndex();
            $data['status'] = $this->search_model->msg;
            $this->load->template('searchindex', $data);
    		}

}

?>
