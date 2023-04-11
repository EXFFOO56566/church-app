<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

/**
 * Class : User (UserController)
 * User Class to control all user related operations
 */
class Livestreams extends BaseController
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->isLoggedIn();
        $this->load->model('livestreams_model');
    }


    public function index(){
      $data['streams'] = $this->livestreams_model->getLiveStreams();
      $this->load->template('livestreams', $data); // this will load the view file
    }

    function updateLiveStreams(){
        $this->load->library('session');
        $this->load->library('form_validation');

        $data = array('title'=>$this->input->post('title'),'stream_url'=>$this->input->post('stream_url')
        ,'type'=>$this->input->post('type')
        ,'status'=>$this->input->post('status'));
        $this->livestreams_model->updateLiveStreams($data);
        $this->load->model('settings_model');
        $server_key = $this->settings_model->getFcmServerKey();
        $this->load->model('fcm_model');
        $this->fcm_model->liveStreamsNotification($server_key,$this->livestreams_model->getLiveStreams());
        if($this->livestreams_model->status == "ok"){
            $this->session->set_flashdata('success', $this->livestreams_model->message);
        }else{
            $this->session->set_flashdata('error', $this->livestreams_model->message);
        }
        redirect('livestreams');
    }
}

?>
