<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Class : Subscription
 * Class verify user subscriptions
 */

 require APPPATH . '/libraries/BaseController.php';

class Subscription extends BaseController
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->check_headers();
    }

    public function index(){
      $data = $this->get_data();

      $status = "error";
      $expiry_date = 0;
      $subscribed = 1;
      if(isset($data->email) && $data->email!=""
      && isset($data->token) && $data->token!=""
      && isset($data->plan) && $data->plan!=""
      && isset($data->packageName) && $data->packageName!=""){

        $packageName = $data->packageName;
        $productId = $data->plan;
        $token = $data->token;
        $this->load->model('subscription_model');
        $this->subscription_model->getSubscriptionData($packageName,$productId,$token);
        $status = $this->subscription_model->status;
        $expiry_date = $this->subscription_model->expiry_date;
        $subscribed = $this->subscription_model->subscribed;

        $this->load->model('account_model');
        $details = array("subscribed"=>$subscribed,"subscribe_token"=>$token,"subscribe_plan"=>$productId,"subscribe_expiry_date"=>$expiry_date);
        $this->account_model->updateUserSubscription($details,$data->email);
      }
      echo json_encode(array("status" => $status,"expiry_date" => $expiry_date));
    }

}

?>
