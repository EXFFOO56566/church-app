<?php
defined('BASEPATH') OR exit('No direct script access allowed');
require APPPATH . '/libraries/BaseController.php';

class Chat extends BaseController
{

   public function __construct(){
        parent::__construct();
        $this->load->model('chat_model');
    }



   public function fetch_user_chats(){
     $data = $this->get_data();
     $results = [];
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $count = 0;
     if(isset($data->count)){
       $count = $data->count;
     }
     $results = $this->chat_model->getUsersChat($email,$count);

     echo json_encode(array("chatsList" => $results));
   }

   public function fetch_user_partner_chat(){
     $data = $this->get_data();
     //var_dump($data);
     $results = [];
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $results = $this->chat_model->fetch_user_partner_chat($email,$partner);
     if($results){
       echo json_encode(array("status" => "ok","chat" => $results));
     }else{
       echo json_encode(array("status" => "none"));
     }

   }

   public function checkfornewmessages(){
    $data = $this->get_data();
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $date = isset($data->date)?filter_var($data->date, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):1602063634;
     $results = $this->chat_model->checkfornewmessages($email,$date);
     echo json_encode(array("status" => "ok","chats" => $results));
   }

   public function load_more_chats(){
    $data = $this->get_data();
     $chat_id = isset($data->chatId)?filter_var($data->chatId, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $count = isset($data->count)?filter_var($data->count, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):20;
     //print($count); die;
     if($chat_id == 0){
         //first we check if a chat have been initiated before
         //between both users and get the chat id
         $chat_id = $this->chat_model->get_user_chatID_if_exists($email,$partner);
     }
     $results = $this->chat_model->get_chat_messages($chat_id,$email,intval($count));
     $have_more_content = $this->chat_model->chats_have_more_content($chat_id, $email,intval($count));
     echo json_encode(array("status" => "ok","chats" => $results,"have_more_content" => $have_more_content));
   }

   public function on_seen_conversation(){
     $data = $this->get_data();
     //var_dump($data);
     $chatid = isset($data->chatid)?filter_var($data->chatid, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     if($chatid == 0){
         //first we check if a chat have been initiated before
         //between both users and get the chat id
         $chatid = $this->chat_model->get_user_chatID_if_exists($email,$partner);
     }
     if($chatid!=0){
       $this->chat_model->on_seen_conversation($chatid,$email);
       //notify user of conversation read
       $this->load->model('settings_model');
       $server_key = $this->settings_model->getFcmServerKey();
       $this->load->model('fcm_model');
    	 $this->fcm_model->userSeenConversationNotification($server_key, $partner, $email, $chatid);
     }
     echo json_encode(array("status" => "ok"));
   }

   public function on_user_typing(){
     $data = $this->get_data();
     //var_dump($data);
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $this->load->model('settings_model');
     $server_key = $this->settings_model->getFcmServerKey();
     $this->load->model('fcm_model');
     $this->fcm_model->userTypingNotification($server_key, $partner, $email);
     echo json_encode(array("status" => "ok"));
   }

   public function update_user_online_status(){
     $data = $this->get_data();
     //var_dump($data);
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $status = isset($data->status)?filter_var($data->status, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):1;
     $this->chat_model->updateUserOnlineStatus($email, $status);
     $this->load->model('settings_model');
     $server_key = $this->settings_model->getFcmServerKey();
     $this->load->model('fcm_model');
     $this->fcm_model->notifyUserOnlinePresence($server_key,$email,$status);
     echo json_encode(array("status" => "ok"));
   }

   public function save_user_conversation(){
     $date = time();
     $chat_id = null !== $this->input->post('chat_id')?filter_var($this->input->post('chat_id'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
     $sender = null !== $this->input->post('sender')?filter_var($this->input->post('sender'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $recipient = null !== $this->input->post('recipient')?filter_var($this->input->post('recipient'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $msg_reciept = null !== $this->input->post('msg_reciept')?filter_var($this->input->post('msg_reciept'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):time();
     $msg_owner = null !== $this->input->post('msg_owner')?filter_var($this->input->post('msg_owner'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $message = null !== $this->input->post('content')?filter_var($this->input->post('content'), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     if($chat_id == 0){
         //first we check if a chat have been initiated before
         //between both users and get the chat id
         $chat_id = $this->chat_model->get_user_chatID_if_exists($sender,$recipient);
         if($chat_id==0){
           $info = array(
               'email1' => $sender,
               'email2' => $recipient,
               'last_message_time' => $date
           );
          $chat_id = $this->chat_model->createUsersChatID($info);
         }

     }else{
       $this->chat_model->updateChatIDLastMessageTime($chat_id, $date);
     }
     $attachment = "";
     if(!empty($_FILES['photo'])){
       $upload = $this->upload_file("photo");
       if($upload[0]=='ok'){
         $attachment =  $upload[1];
       }else{
         echo json_encode(array("status" => "error","msg" => $upload[1]));
         exit;
       }
     }

     //check if this user is blocked from sending messages
     $isUserBlocked1 = $this->chat_model->verifyIfPartnerIsBlocked($sender,$recipient);
     $isUserBlocked2 = $this->chat_model->verifyIfPartnerIsBlocked($recipient,$sender);

     //save message for sender
     $msg1 = array(
         'chat_id' => $chat_id,
         'message' => $message,
         'attachment' => $attachment,
         'sender' => $sender,
         'msg_reciept' => $msg_reciept,
         'msg_owner' => $msg_owner,
         'date' => $date
     );
      //save for sender
      $this->chat_model->saveUserChatConversation($msg1);

      //if none of the users blocked the other, we save and send notification
      if($isUserBlocked1 != 0 && $isUserBlocked2 != 0){
        //save message for reciever
        $msg2 = array(
            'chat_id' => $chat_id,
            'message' => $message,
            'attachment' => $attachment,
            'sender' => $sender,
            'msg_reciept' => $msg_reciept,
            'msg_owner' => $recipient,
            'date' => $date
        );
        //save for recipient
        $converseID = $this->chat_model->saveUserChatConversation($msg2);
        $unseen = $this->chat_model->get_unseen_messages($chat_id,$recipient);
        //send notification to recipient
        $chatsender = $this->chat_model->getRecipientDetails($sender);
        /*$notificationmessage = "Sent a photo";
        if($message!=""){
          $notifcationmessage = substr(base64_decode($message),100);
        }*/
        $chat = $this->chat_model->getUserLastConversation($converseID);
        $this->load->model('settings_model');
        $server_key = $this->settings_model->getFcmServerKey();
        $this->load->model('fcm_model');
        $this->fcm_model->userConversationNotification($server_key, $recipient, $chatsender, $unseen, $chat);
      }
     echo json_encode(array("status" => "ok","chatid" => $chat_id));
   }

   function delete_selected_chat_messages(){
     $data = $this->get_data();
     //var_dump($data);
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $chatid = isset($data->chatid)?filter_var($data->chatid, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
     $msgReciepts = $data->msgReciepts;
     if($chatid == 0){
         //first we check if a chat have been initiated before
         //between both users and get the chat id
         $chatid = $this->chat_model->get_user_chatID_if_exists($email,$partner);
     }
     $chat = $this->chat_model->delete_selected_chat_messages($email, $chatid, $msgReciepts);
     echo json_encode(array("status" => "ok"));
   }

   function clear_user_conversation(){
     $data = $this->get_data();
     //var_dump($data);
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $chatid = isset($data->chatid)?filter_var($data->chatid, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
     if($chatid == 0){
         //first we check if a chat have been initiated before
         //between both users and get the chat id
         $chatid = $this->chat_model->get_user_chatID_if_exists($email,$partner);
     }
     $chat = $this->chat_model->clear_user_chat_messages($email, $chatid, $msgReciepts);
     echo json_encode(array("status" => "ok"));
   }

   function blockUnblockUser(){
     $data = $this->get_data();
     //var_dump($data);
     $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $partner = isset($data->partner)?filter_var($data->partner, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
     $status = isset($data->status)?filter_var($data->status, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):1;

     if($status == 0){
       $info = array(
           'blocked_user' => $partner,
           'blocked_by' => $email
       );
       $this->chat_model->blockUser($info);
     }else{
       $this->chat_model->unblockUser($partner, $email);
     }

     echo json_encode(array("status" => "ok"));
   }


   public function upload_file($file){
 		$path = $_FILES[$file]['name'];
 		$ext = pathinfo($path, PATHINFO_EXTENSION);

    $new_name = uniqid()."_photo_".time().".".$ext;
    $config['file_name'] = $new_name;
    $config['upload_path'] = './uploads/socials/chats';
 		$config['max_size']             = 10000;
 		$config['allowed_types']        = '*';
 		$config['overwrite'] = TRUE; //overwrite thumbnail
 		$this->load->library('upload');
 		$this->upload->initialize($config);
 		if (!$this->upload->do_upload($file))
 		{
 				//$error = array('error' => $this->upload->display_errors());
 				return ['error',strip_tags($this->upload->display_errors())];
 		}
 		else{
 				return ['ok',$new_name];
 		}
 	}

}
