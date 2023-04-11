<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Socials_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Error processing requested operation';

    /**
     * This function is used to delete the user information
     * @param number $userId : This is user id
     * @return boolean $result : TRUE / FALSE
     */
    function deleteSocialToken($token){
        $this->db->where('token', $token);
        $this->db->delete('tbl_social_fcm_tokens');
    }

    /**
     * This function is used to store user fcm token
     */
    function updateUserSocialFcmToken($token)
    {
      $this->db->trans_start();
      $this->db->insert('tbl_social_fcm_tokens', $token);
      $this->db->trans_complete();
      $this->status = 'ok';
      $this->message = 'token added successfully';
    }

    function getUserSocialProfile($email){
      $this->db->select('tbl_user_profile.*');
      $this->db->from('tbl_user_profile');
      $this->db->where('email',$email);
      $query = $this->db->get();
      $user = $query->row();
      if($user){
        return TRUE;
      }else{
        return FALSE;
      }
    }

    function addNewUserProfile($user){
      $this->db->trans_start();
      $this->db->insert('tbl_user_profile', $user);
      $this->db->trans_complete();
    }


    function editUserProfile($user, $email){
      $this->db->where('email', $email);
      $this->db->update('tbl_user_profile', $user);
    }

    function editUserName($user, $email){
      $this->db->where('email', $email);
      $this->db->update('tbl_android_users', $user);
    }

    function usersToFollowListing($page = 0, $query = "", $email=""){
      $this->db->select('tbl_android_users.name,tbl_user_profile.*');
      $this->db->from('tbl_android_users');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_android_users.email !=', $email);
      //$this->db->where('tbl_user_following._ignore',0);
      if($query!=""){
          $this->db->like('tbl_android_users.name', $query);
          //$this->db->or_like('tbl_user_profile.location', $query);
      }
      $this->db->order_by('tbl_android_users.name','ASC');
      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      $result = $query->result();
      foreach ($result as $res) {
        $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
        $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
        $res->following = $this->getFollowStatus($res->email,$email);
      }
      if($result){
        return $result;
      }else{
        return [];
      }
    }

    function getUsersFollowingEmails($email){
      $this->db->select('tbl_user_following.user_email');
      $this->db->from('tbl_user_following');
      $this->db->where('tbl_user_following.follower_email',$email);
      $query = $this->db->get();
      $result = $query->result_array();
      var_dump($result); die;
    }

    function users_followers_people($page = 0, $user, $email){
      $this->db->select('tbl_user_following.*, tbl_android_users.name,tbl_user_profile.*');
      $this->db->from('tbl_user_following');
      $this->db->join('tbl_android_users','tbl_user_following.follower_email=tbl_android_users.email');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_user_following.user_email',$user);
      $this->db->where('tbl_user_following._ignore',0);
      $this->db->order_by('tbl_android_users.name','ASC');
      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      $result = $query->result();
      foreach ($result as $res) {
        $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
        $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
        $res->following = $this->getFollowStatus($res->email,$email);
      }
      if($result){
        return $result;
      }else{
        return [];
      }
    }

    function users_following_people($page = 0, $user, $email){
      $this->db->select('tbl_user_following.*, tbl_android_users.name,tbl_user_profile.*');
      $this->db->from('tbl_user_following');
      $this->db->join('tbl_android_users','tbl_user_following.user_email=tbl_android_users.email');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_user_following.follower_email',$user);
      $this->db->where('tbl_user_following._ignore',0);
      $this->db->order_by('tbl_android_users.name','ASC');
      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      $result = $query->result();
      foreach ($result as $res) {
        $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
        $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
        $res->following = $this->getFollowStatus($res->email,$email);
      }
      if($result){
        return $result;
      }else{
        return [];
      }
    }


    function post_likes_people($page = 0, $post, $email){
      $this->db->select('tbl_post_likes.email, tbl_android_users.name,tbl_user_profile.*');
      $this->db->from('tbl_post_likes');
      $this->db->join('tbl_android_users','tbl_android_users.email=tbl_post_likes.email');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_post_likes.post_id',$post);
      $this->db->order_by('tbl_post_likes.date','DESC');
      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      $result = $query->result();
      foreach ($result as $res) {
        $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
        $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
        $res->following = $this->getFollowStatus($res->email,$email);
      }
      if($result){
        return $result;
      }else{
        return [];
      }
    }

    function userNotifications($page = 0, $email){
      $this->db->select('tbl_notifications.*, tbl_android_users.name,tbl_user_profile.avatar, tbl_user_profile.cover_photo');
      $this->db->from('tbl_notifications');
      $this->db->join('tbl_android_users','tbl_android_users.email=tbl_notifications.email');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_notifications.user',$email);
      $this->db->order_by('tbl_notifications.timestamp','DESC');
      if($page!=0){
          $this->db->limit(20,$page * 20);
      }else{
        $this->db->limit(20);
      }

      $query = $this->db->get();
      $result = $query->result();
      foreach ($result as $res) {
        $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
        $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
        $res->following = $this->getFollowStatus($res->email,$email);

        if($res->type == "follow"){
            $res->message = "Started following you";
  			}else if($res->type == "comment"){
            $res->message = "Commented on your post";
              $res->post = $this->get_postData($res->itm_id, $email);
  			}else if($res->type == "like"){
            $res->message = "Liked your post";
              $res->post = $this->get_postData($res->itm_id, $email);
  			}
      }
      if($result){
        return $result;
      }else{
        return [];
      }
    }

    public function get_total_users($email,$query=""){
      $this->db->select('tbl_android_users.name,tbl_user_profile.*');
      $this->db->from('tbl_android_users');
      $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
      $this->db->where('tbl_android_users.email !=', $email);
      if($query!=""){
          $this->db->like('tbl_android_users.name', $query);
          $this->db->or_like('tbl_user_profile.location', $query);
      }
      $query = $this->db->get();
      $result = $query->result();
      return count((array) $result);
   }

   function getFollowStatus($user,$follower){
     $this->db->select('tbl_user_following.id');
     $this->db->from('tbl_user_following');
     $this->db->where('user_email',$user);
     $this->db->where('follower_email',$follower);
     $query = $this->db->get();
     $status = $query->row();
     if($status){
       return 0;
     }else{
       return 1;
     }
   }

   function getuserBioInfo($email){
     $this->db->select('tbl_android_users.*,tbl_user_profile.*');
     $this->db->from('tbl_android_users');
     $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
     $this->db->where('tbl_android_users.email',$email);
     $query = $this->db->get();
     $user = $query->row();
     if($user){
        $user->activated = 1;
        $user->avatar = base_url()."uploads/socials/avatars/".$user->avatar;
        $user->cover_photo = $user->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$user->cover_photo;
       return $user;
     }else{
       return null;
     }
   }

   function getUpdatedUserProfile($email){
     $this->db->select('tbl_android_users.*,tbl_user_profile.*');
     $this->db->from('tbl_android_users');
     $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
     $this->db->where('tbl_android_users.email',$email);
     $query = $this->db->get();
     $user = $query->row();
     if($user){
        $user->activated = 1;
        $user->avatar = base_url()."uploads/socials/avatars/".$user->avatar;
        $user->cover_photo = $user->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$user->cover_photo;
       return $user;
     }else{
       return null;
     }
   }

   function followUser($data){
     if($this->getFollowStatus($data['user_email'],$data['follower_email']) == 1){
       $this->db->trans_start();
       $this->db->insert('tbl_user_following', $data);
       $this->db->trans_complete();
     }
   }

   function unfollowUser($user,$follower){
     $this->db->where('user_email',$user);
     $this->db->where('follower_email',$follower);
     $this->db->delete('tbl_user_following');
   }

   function saveUserPost($info)
   {
     $this->db->trans_start();
     $this->db->insert('tbl_user_posts', $info);
     $this->status = 'ok';
     $this->message = 'Post added Uploaded successfully';
     $insert_id = $this->db->insert_id();
     $this->db->trans_complete();
     return $insert_id;
   }


   public function fetch_posts($page = 0,$email=""){
    // $this->getUsersFollowingEmails($email);
       $this->db->select('tbl_user_following.id as follower_id, tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_user_posts');
       $this->db->join('tbl_user_following','tbl_user_following.user_email = tbl_user_posts.email');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       //
       //$this->db->where('tbl_user_posts.email',$email);
       $this->db->where('tbl_user_following.follower_email',$email);
       //$this->db ->where('tbl_user_posts.email in', '(select user_email from tbl_user_following where follower_email = tbl_user_following.`sales.envisionapps@gmail.com`)', false);

       $this->db->where('tbl_user_posts.deleted',1);
       $this->db->order_by('tbl_user_posts.id','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       //var_dump($query); die;
       $result = $query->result();

       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }

   public function fetch_posts_flutter($page = 0,$email=""){
    // $this->getUsersFollowingEmails($email);
       $this->db->select('tbl_user_following.id as follower_id, tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_user_posts');
       $this->db->join('tbl_user_following','tbl_user_following.user_email = tbl_user_posts.email');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       //
       //$this->db->where('tbl_user_posts.email',$email);
       $this->db->where('tbl_user_following.follower_email',$email);
       //$this->db ->where('tbl_user_posts.email in', '(select user_email from tbl_user_following where follower_email = tbl_user_following.`sales.envisionapps@gmail.com`)', false);

       $this->db->where('tbl_user_posts.deleted',1);
       $this->db->order_by('tbl_user_posts.id','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       //var_dump($query); die;
       $result = $query->result();

       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->content!=""){
           $res->content = base64_decode($res->content);
         }
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }


   public function fetch_postsCopy($page = 0,$email=""){
       $this->db->select('tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_user_posts');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       $this->db->where('tbl_user_posts.deleted',1);
       $this->db->order_by('tbl_user_posts.id','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       var_dump($result); die;
       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }


   public function fetch_user_posts($page = 0, $user, $email="", $me=FALSE){
       $this->db->select('tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_user_posts');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       $this->db->where('tbl_user_posts.email',$user);
       if($me==FALSE){
         $this->db->where('tbl_user_posts.visibility',"public");
       }
       $this->db->where('tbl_user_posts.deleted',1);

       $this->db->order_by('tbl_user_posts.id','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }


   public function fetch_user_posts_fluter($page = 0, $user, $email="", $me=FALSE){
       $this->db->select('tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_user_posts');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       $this->db->where('tbl_user_posts.email',$user);
       if($me==FALSE){
         $this->db->where('tbl_user_posts.visibility',"public");
       }
       $this->db->where('tbl_user_posts.deleted',1);

       $this->db->order_by('tbl_user_posts.id','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->content!=""){
           $res->content = base64_decode($res->content);
         }
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }


   public function fetchUserPins($page = 0, $email=""){
       $this->db->select('tbl_post_pins.post_id, tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_post_pins');
       $this->db->join('tbl_user_posts','tbl_user_posts.id = tbl_post_pins.post_id');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       $this->db->where('tbl_post_pins.email',$email);
       $this->db->where('tbl_user_posts.deleted',1);
       $this->db->order_by('tbl_post_pins.date','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }

   public function fetchUserPinsFlutter($page = 0, $email=""){
       $this->db->select('tbl_post_pins.post_id, tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
       $this->db->from('tbl_post_pins');
       $this->db->join('tbl_user_posts','tbl_user_posts.id = tbl_post_pins.post_id');
       $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
       $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
       $this->db->where('tbl_post_pins.email',$email);
       $this->db->where('tbl_user_posts.deleted',1);
       $this->db->order_by('tbl_post_pins.date','DESC');
       if($page!=0){
           $this->db->limit(20,$page * 20);
       }else{
         $this->db->limit(20);
       }

       $query = $this->db->get();
       $result = $query->result();
       foreach ($result as $res){
         $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
         $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
         $res->comments_count = $this->get_total_comments($res->id);
         $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
         $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
         if($res->content!=""){
           $res->content = base64_decode($res->content);
         }
         if($res->media != ""){
           $media = json_decode($res->media);
           $res->media = [];
           foreach ($media as $mdia) {
               if($this->get_extension($mdia) == "mp4"){
                  $mdia = base_url()."uploads/socials/videos/".$mdia;
                }else{
                  $mdia = base_url()."uploads/socials/photos/".$mdia;
               }
               array_push($res->media, $mdia);
           }
           //var_dump($res->media); die;
         }
       }
       return $result;
   }

   public function get_user_total_posts($email, $me = FALSE){
     $this->db->select("COUNT(*) as num");
     $this->db->from('tbl_user_posts');
     $this->db->where('tbl_user_posts.email',$email);
     if($me==FALSE){
       $this->db->where('tbl_user_posts.visibility',"public");
     }
     $query = $this->db->get();
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

  public function get_user_total_pins($email){
    $this->db->select('tbl_post_pins.post_id, tbl_user_posts.id');
    $this->db->from('tbl_post_pins');
    $this->db->join('tbl_user_posts','tbl_user_posts.id = tbl_post_pins.post_id');
    $this->db->where('tbl_post_pins.email',$email);
    $this->db->where('tbl_user_posts.deleted',1);
    $query = $this->db->get();
    return count((array)$query->result());
 }

   public function get_extension($file){
      $array = explode('.', $file);
      return end($array);
   }

   public function get_total_posts($email=""){
     $this->db->select("COUNT(*) as num");
     $this->db->from('tbl_user_posts');
     $this->db->where('deleted',1);
     if($email!=""){
       $this->db->where('email',$email);
     }
     $query = $this->db->get();
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

  public function likeunlikepost($id,$email,$action="like"){
    $check = $this->checkIfUserLikedPost($id,$email);
    if($action=="unlike" && $check == true){
      $this->db->where('post_id', $id);
      $this->db->where('email', $email);
      $this->db->delete('tbl_post_likes');

      //update total likes on media
      $this->db->set('likes_count', '`likes_count`- 1', false);
      $this->db->where('id' , $id);
      $this->db->update('tbl_user_posts');
      $this->status = "ok";
      $this->message = 'post unliked successfully';
    }else if($check == false){
      $data = ['post_id' => $id,'email' => $email ,'date' => time()];
      $this->db->insert('tbl_post_likes', $data);

      //update total likes on media
      $this->db->set('likes_count', '`likes_count`+ 1', false);
      $this->db->where('id' , $id);
      $this->db->update('tbl_user_posts');
      $this->status = "ok";
      $this->message = 'post liked successfully';
    }else{
      $this->status = "ok";
      $this->message = 'success';
    }
  }

  public function checkIfUserLikedPost($id,$email){
      $this->db->select('tbl_post_likes.id');
      $this->db->from('tbl_post_likes');
      $this->db->where('post_id',$id);
      $this->db->where('email',$email);
      $query = $this->db->get();
      return count((array)$query->result())>0?true:false;
  }



  public function pinunpinpost($id,$email,$action="like"){
    $check = $this->checkIfPinnedPost($id,$email);
    if($action=="unpin" && $check == true){
      $this->db->where('post_id', $id);
      $this->db->where('email', $email);
      $this->db->delete('tbl_post_pins');
      $this->status = "ok";
      $this->message = 'post unpinned successfully';
    }else if($check == false){
      $data = ['post_id' => $id,'email' => $email ,'date' => time()];
      $this->db->insert('tbl_post_pins', $data);
      $this->status = "ok";
      $this->message = 'post pinned successfully';
    }else{
      $this->status = "ok";
      $this->message = 'success';
    }
  }

  public function checkIfPinnedPost($id,$email){
      $this->db->select('tbl_post_pins.id');
      $this->db->from('tbl_post_pins');
      $this->db->where('post_id',$id);
      $this->db->where('email',$email);
      $query = $this->db->get();
      return count((array)$query->result())>0?true:false;
  }


  public function get_total_comments($id){
    $query = $this->db->select("COUNT(*) as num")->where('post_id',$id)->where('deleted',1)->get("tbl_post_comments");
    $result = $query->row();
    if(isset($result)) return $result->num;
    return 0;
   }

   public function editpost($id,$content,$visibility){
     $data = ['content' => $content, 'visibility' => $visibility, 'edited' => 0];
     $this->db->where('id', $id);
     $this->db->update('tbl_user_posts', $data);
     $this->status = "ok";
     $this->message = 'post edited successfully';
   }

   public function deletepost($id){
     $data = ['deleted' => 0];
     $this->db->where('id', $id);
     $this->db->update('tbl_user_posts', $data);
     $this->status = "ok";
     $this->message = 'post edited successfully';
   }

   public function deleteNotification($id){
     $this->db->where('id', $id);
     $this->db->delete('tbl_notifications');
     $this->status = "ok";
     $this->message = 'Notification deleted successfully';
   }

   public function setSeenNotifications($email){
     $data = ['status' => 0];
     $this->db->where('user', $email);
     $this->db->update('tbl_notifications', $data);
     $this->status = "ok";
     $this->message = 'Notifications edited successfully';
   }

   public function getUsersFollowersCount($email=""){
     $this->db->select("COUNT(*) as num");
     $this->db->from('tbl_user_following');
     $this->db->where('tbl_user_following._ignore',0);
     if($email!=""){
       $this->db->where('user_email',$email);
     }
     $query = $this->db->get();
     $result = $query->row();
     if(isset($result)) return $result->num;
     return 0;
  }

  public function getUsersPostLikesCount($post){
    $this->db->select("COUNT(*) as num");
    $this->db->from('tbl_post_likes');
    $this->db->where('post_id',$post);
    $query = $this->db->get();
    $result = $query->row();
    if(isset($result)) return $result->num;
    return 0;
 }

 public function getUsersNotificationCount($email, $unseen = FALSE){
   $this->db->select("COUNT(*) as num");
   $this->db->from('tbl_notifications');
   $this->db->where('user',$email);
   if($unseen == TRUE){
     $this->db->where('status',1);
   }
   $query = $this->db->get();
   $result = $query->row();
   if(isset($result)) return $result->num;
   return 0;
}

  public function getUsersFollowingCount($email=""){
    $this->db->select("COUNT(*) as num");
    $this->db->from('tbl_user_following');
    $this->db->where('tbl_user_following._ignore',0);
    if($email!=""){
      $this->db->where('follower_email',$email);
    }
    $query = $this->db->get();
    $result = $query->row();
    if(isset($result)) return $result->num;
    return 0;
 }

 public function updateUserSettings($settings, $email){
   $this->db->where('email', $email);
   $this->db->update('tbl_user_profile', $settings);
   $this->status = "ok";
   $this->message = 'settings updated successfully';
 }

 function fetch_user_settings($email){
   $this->db->select('tbl_user_profile.show_dateofbirth, tbl_user_profile.show_phone, tbl_user_profile.notify_follows,
                     tbl_user_profile.notify_comments, tbl_user_profile.notify_likes');
   $this->db->from('tbl_user_profile');
   $this->db->where('email',$email);
   $query = $this->db->get();
   return $query->row();
 }

 public function saveNotificationData($itm_id,$type,$email,$user){
   $data = array('itm_id' => $itm_id,'type' => $type,'user' => $user,'email' => $email ,'timestamp' => time());
   $this->db->insert('tbl_notifications', $data);
 }

 public function get_postData($id = 0, $email=""){
   $this->db->select('tbl_user_posts.*, tbl_user_profile.id AS userId, tbl_user_profile.avatar, tbl_user_profile.cover_photo, tbl_android_users.name');
   $this->db->from('tbl_user_posts');
   $this->db->join('tbl_user_profile','tbl_user_profile.email = tbl_user_posts.email');
   $this->db->join('tbl_android_users','tbl_android_users.email = tbl_user_posts.email');
   $this->db->where('tbl_user_posts.deleted',1);
   $this->db->where('tbl_user_posts.id',$id);


   $query = $this->db->get();
   $res = $query->row();
   if($res){
     $res->avatar = base_url()."uploads/socials/avatars/".$res->avatar;
     $res->cover_photo = $res->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$res->cover_photo;
     $res->comments_count = $this->get_total_comments($res->id);
     $res->isLiked = $this->checkIfUserLikedPost($res->id,$email);
     $res->isPinned = $this->checkIfPinnedPost($res->id,$email);
     $res->fluttercontent = "";
     if($res->content!=""){
       $res->fluttercontent = base64_decode($res->content);
     }
     if($res->media != ""){
       $media = json_decode($res->media);
       $res->media = [];
       foreach ($media as $mdia) {
           if($this->get_extension($mdia) == "mp4"){
              $mdia = base_url()."uploads/socials/videos/".$mdia;
            }else{
              $mdia = base_url()."uploads/socials/photos/".$mdia;
           }
           array_push($res->media, $mdia);
       }
       //var_dump($res->media); die;
     }
   }
   return $res;
 }

 


}
