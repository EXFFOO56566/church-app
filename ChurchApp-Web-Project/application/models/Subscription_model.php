<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

include_once './vendor/autoload.php';
class Subscription_model extends CI_Model{

  public $status = "error";
  public $expiry_date = 0;
  public $subscribed = 1;
  private $GOOGLE_JSON_FILE = "uploads/api-7904900893803879423-558785-0eca16302037.json";

 public function getSubscriptionData($packageName,$productId,$token){
   $client = new \Google_Client();
   $client->setAuthConfig($this->GOOGLE_JSON_FILE);
   $client->addScope('https://www.googleapis.com/auth/androidpublisher');
   $service = new \Google_Service_AndroidPublisher($client);
     try {
       $this->status = "ok";
       $purchase = $service->purchases_subscriptions->get($packageName, $productId, $token);
       $this->expiry_date = $purchase->expiryTimeMillis;
       if($this->isValidFutureDate($this->expiry_date)){
         $this->subscribed = 0;
       }
     } catch (\Exception $e){
       //var_dump($e->getMessage());
       // example message: Error calling GET ....: (404) Product not found for this application.
     }
 }

 private function isValidFutureDate($date){
     if(($date/1000) > time()){
        return true;
     }else{
       return false;
     }
 }

}
