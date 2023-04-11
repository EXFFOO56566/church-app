<?php
defined('BASEPATH') OR exit('No direct script access allowed');

include_once './vendor/autoload.php';
require APPPATH . '/libraries/BaseController.php';

/*
* This class handles some of the requests from the android client app
*/
class Stripe extends BaseController {

	public function __construct()
    {
        parent::__construct();
				\Stripe\Stripe::setApiKey('sk_test_6xUByjFffp27HVRYr97f7aBh0095NrAQQq');
    }


   function index(){

		$customer = \Stripe\Customer::create([
		    'description' => 'example customer',
		    'email' => 'email@example.com',
		    'payment_method' => 'pm_card_visa',
		]);
		echo $customer;
	 }

	 function createCustomer(){
		 $key = \Stripe\EphemeralKey::create(
		  ['customer' => "help.envisionaps@gmail.com"],
		  ['stripe_version' => '2020-03-02']
		);
	 }



}
