<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Fcm_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Error processing requested operation';


    /**
     * This function is used to store user fcm token
     */
    function storeUserFcmToken($token)
    {
      $this->db->trans_start();
      $token['date'] = date('Y-m-d H:i:s');
      $this->db->insert('tbl_fcm_token', $token);
      $insert_id = $this->db->insert_id();
      $this->db->trans_complete();
      $this->status = 'ok';
      $this->message = 'token added successfully';
    }

    function updateUserFcmToken($token,$version){
      $data['app_version'] = $version;
      $this->db->where('token',$token);
      $this->db->update('tbl_fcm_token', $data);
      $this->status = 'ok';
      $this->message = 'token updated successfully';
    }

    function androidUsersTokenListing(){
        $this->db->select('tbl_fcm_token.token');
        $this->db->from('tbl_fcm_token');
        $query = $this->db->get();
        //var_dump($query); die;
        $result =  $query->result();
        //var_dump($result); die;
        $token = [];
        foreach ($result as $res) {
          array_push($token,$res->token);
        }
        //var_dump($token); die;
        return $token;
    }

    function AllUsersSocialTokenListing($email = "null"){
        $this->db->select('tbl_social_fcm_tokens.token');
        $this->db->from('tbl_social_fcm_tokens');
        $this->db->where('email !=',$email);
        $query = $this->db->get();
        //var_dump($query); die;
        $result =  $query->result();
        //var_dump($result); die;
        $token = [];
        foreach ($result as $res) {
          array_push($token,$res->token);
        }
        //var_dump($token); die;
        return $token;
    }

    function usersSocialTokenListing($email){
        $this->db->select('tbl_social_fcm_tokens.token');
        $this->db->from('tbl_social_fcm_tokens');
        $this->db->where('email',$email);
        $query = $this->db->get();
        //var_dump($query); die;
        $result =  $query->result();
        //var_dump($result); die;
        $token = [];
        foreach ($result as $res) {
          array_push($token,$res->token);
        }
        //var_dump($token); die;
        return $token;
    }

    function tokenListing($updated_version=""){
        $this->db->select('tbl_fcm_token.token');
        $this->db->from('tbl_fcm_token');
        if($updated_version!=""){
          $this->db->where('app_version !=','v1');
        }
        $query = $this->db->get();
        //var_dump($query); die;
        $result =  $query->result();
        //var_dump($result); die;
        $token = [];

        foreach ($result as $res) {
          array_push($token,$res->token);
        }
        //var_dump($token); die;
        return $token;
    }

    public function sendPushNotificationToFCMSever($API_SERVER_KEY,$title, $message) {

        $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
          // var_dump(sizeof($tokens)); //die;
          for($i=0; $i<sizeof($tokens); $i++){
             // var_dump($tokens[$i]); die;
             $fields = array(
              'registration_ids' => $tokens[$i],
              'priority' => 10,
                'notification' => array( 'title' => $title, 'body' =>  $message ),
          );
            $fields['time_to_live'] = 1200;
            //$fields['time_to_live'] = 3600000;
          $this->push_data($API_SERVER_KEY,$fields);
          }
    }

    public function sendUserRelatedPushNotification($API_SERVER_KEY,$email,$action) {
        $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
          // var_dump(sizeof($tokens)); //die;
          for($i=0; $i<sizeof($tokens); $i++){
             // var_dump($tokens[$i]); die;
             $fields = array(
              'registration_ids' => $tokens[$i],
              'priority' => 10,
              'data' => array('email' => $email, 'action' =>  $action),
          );
            $fields['time_to_live'] = 1200;
            //$fields['time_to_live'] = 3600000;
          $this->push_data($API_SERVER_KEY,$fields);
          }
    }


    public function newMediaNotification($API_SERVER_KEY,$title,$media) {

        $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
          // var_dump(sizeof($tokens)); //die;
          for($i=0; $i<sizeof($tokens); $i++){
             // var_dump($tokens[$i]); die;
             $fields = array(
              'registration_ids' => $tokens[$i],
              'priority' => 10,
              'data' => array('title' => $title, 'action' =>  "newMedia", 'media' => json_encode($media)),
          );
            $fields['time_to_live'] = 120000;
            //$fields['time_to_live'] = 3600000;
          $this->push_data($API_SERVER_KEY,$fields);
          }
    }

    public function editMediaNotification($API_SERVER_KEY,$media) {

        $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
          // var_dump(sizeof($tokens)); //die;
          for($i=0; $i<sizeof($tokens); $i++){
             // var_dump($tokens[$i]); die;
             $fields = array(
              'registration_ids' => $tokens[$i],
              'priority' => 10,
              'data' => array('action' =>  "editMedia", 'media' => json_encode($media)),
          );
            $fields['time_to_live'] = 1200;
            //$fields['time_to_live'] = 3600000;
          $this->push_data($API_SERVER_KEY,$fields);
          }
    }

    public function push_event_data($API_SERVER_KEY,$event) {
      //var_dump($article); die;
     $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
       // var_dump(sizeof($tokens)); //die;
       for($i=0; $i<sizeof($tokens); $i++){
          // var_dump($tokens[$i]); die;
          $fields = array(
           'registration_ids' => $tokens[$i],
           'priority' => 10,
           'data' => array('title' => $event->title, 'action' =>  "events", 'events' => json_encode($event)),
       );
         $fields['time_to_live'] = 2419200;
         //$fields['time_to_live'] = 3600000;
       $this->push_data($API_SERVER_KEY,$fields);
       }
   }

   public function push_inbox_data($API_SERVER_KEY,$inbox) {
     //var_dump($inbox); die;
      $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
      // var_dump(sizeof($tokens)); //die;
      for($i=0; $i<sizeof($tokens); $i++){
         // var_dump($tokens[$i]); die;
         $fields = array(
          'registration_ids' => $tokens[$i],
          'priority' => 10,
          'data' => array('title' => $inbox->title, 'action' =>  "inbox", 'inbox' => json_encode($inbox)),
      );
        $fields['time_to_live'] = 2419200;
        //$fields['time_to_live'] = 3600000;
      $this->push_data($API_SERVER_KEY,$fields);
      }
  }

   public function liveStreamsNotification($API_SERVER_KEY,$livestream){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->androidUsersTokenListing(), 1000);
         // var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => $livestream->title, 'action' =>  "livestream", 'livestream' => json_encode($livestream))
            //  'data' => array('title' => $livestream->title, 'action' =>  "livestream", 'stream_url' => $livestream, 'status' => $status==0?"active":"inactive")
           );
           $fields['time_to_live'] = 3600;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

   public function userActionsNotification($API_SERVER_KEY, $email, $avatar,$msg){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->usersSocialTokenListing($email), 1000);
       //var_dump($tokens); die;
          //var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => "New Notification", 'action' =>  "social_notify", 'email' => $email, 'avatar' => $avatar, 'message' => $msg)
            //  'data' => array('title' => $livestream->title, 'action' =>  "livestream", 'stream_url' => $livestream, 'status' => $status==0?"active":"inactive")
           );
           $fields['time_to_live'] = 7200;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

   public function userConversationNotification($API_SERVER_KEY, $email, $user, $unseen, $chat){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->usersSocialTokenListing($email), 1000);
         //var_dump($tokens); die;
          //var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => $email, 'action' =>  "chat", 'chat' => json_encode($chat) , 'user' => json_encode($user))
           );
           $fields['time_to_live'] = 2419200;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

   public function userSeenConversationNotification($API_SERVER_KEY, $email, $recipient, $chatid ){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->usersSocialTokenListing($email), 1000);
         //var_dump($tokens); die;
          //var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => "Read Conversation", 'action' =>  "read_conversation", 'email' => $recipient, 'chatid' => $chatid )
           );
           $fields['time_to_live'] = 7200;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

   public function userTypingNotification($API_SERVER_KEY, $email, $recipient){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->usersSocialTokenListing($email), 1000);
         //var_dump($tokens); die;
          //var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => "Read Conversation", 'action' =>  "user_typing", 'email' => $recipient)
           );
           $fields['time_to_live'] = 7200;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

   public function notifyUserOnlinePresence($API_SERVER_KEY, $email, $status){
      // var_dump($livestream); die;
       $tokens = array_chunk($this->AllUsersSocialTokenListing($email), 1000);
         //var_dump($tokens); die;
          //var_dump(sizeof($tokens)); //die;
         for($i=0; $i<sizeof($tokens); $i++){
            // var_dump($tokens[$i]); die;
            $fields = array(
             'registration_ids' => $tokens[$i],
             'priority' => 10,
             'data' => array('title' => "Online Status", 'action' =>  "online_status", 'email' => $email, 'status' => $status, 'last_seen' => time())
           );
           $fields['time_to_live'] = 7200;
           //$fields['time_to_live'] = 3600000;
         $this->push_data($API_SERVER_KEY,$fields);
         }
   }

    private function push_data($API_SERVER_KEY,$fields){
      //echo $API_SERVER_KEY; die;
      $path_to_firebase_cm = 'https://fcm.googleapis.com/fcm/send';
      $headers = array(
          'Authorization:key=' . $API_SERVER_KEY,
          'Content-Type:application/json'
      );
      // Open connection
      $ch = curl_init();
      // Set the url, number of POST vars, POST data
      curl_setopt($ch, CURLOPT_URL, $path_to_firebase_cm);
      curl_setopt($ch, CURLOPT_POST, true);
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
      curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
      curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
      // Execute post
      $result = curl_exec($ch);
      //var_dump($result); die;
      // Close connection
      curl_close($ch);
      $res = json_decode($result);
      //var_dump($res); die;
      //var_dump($res->results[0]->error);
      if(isset($res->results[0]->error) && $res->results[0]->error!='NotRegistered'){//NotRegistered, common error when a user uninstalls the app causing the token to be invalide
        $this->status = "error";
        $this->message = $res->results[0]->error;
      }else{
        $this->status = "ok";
        $this->message = "Message sent Successfully";
      }
    }
}
