<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class Install_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Error processing requested operation';

  public function __construct(){
        parent::__construct();
        $this->load->dbforge();
    }

    public function create_users_table(){
      echo ".......................................................................................<br>";
      echo "Create new Admin User table <br>";
      $db_1 = $this->dbforge;
      $db_1->add_field(array(
                       'id' => array(
                               'type' => 'INT',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),
                       'email' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '100',
                       ),
                       'password' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '200',
                       ),
                       'fullname' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '200',
                       ),
               ));
               $this->dbforge->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_users')){
                 echo "Admin Users table skipped..... Reason: already exists";
               }else{
                 $db_1->create_table('tbl_users');
                 $this->addNewAdmin(array(
                     'fullname'       => "New Admin User",
                     'email'      => "admin@admin.com",
                     'password'   => "admin"
                 ));
                 echo "Admin Users table Created successfully";
               }
    }

    /**
     * This function is used to add new admin credentials to the database
     */
    function addNewAdmin($userInfo){
      echo "insert new Admin user to admin users table <br>";
      echo "Email: ".$userInfo['email'] . "<br>";
      echo "Password: ".$userInfo['password']. "<br>";
      $userInfo['password'] = getHashedPassword($userInfo['password']);
      $this->db->trans_start();
      $this->db->insert('tbl_users', $userInfo);
      $insert_id = $this->db->insert_id();
      $this->db->trans_complete();
    }

    public function create_settings_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Settings table <br>";
      $db_2 = $this->dbforge;
      $db_2->add_field(array(
                       'id' => array(
                               'type' => 'INT'
                       ),
                       'fcm_server_key' => array(
                               'type' => 'text',
                       ),
                       'mail_username' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '200',
                       ),
                       'mail_password' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '200',
                       ),
                       'mail_smtp_host' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '100',
                       ),
                       'mail_protocol' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '50',
                       ),
                       'mail_port' => array(
                               'type' => 'int'
                       ),
               ));
               $db_2->add_key('id', TRUE);
               if ($this->db->table_exists('settings')){
                 echo "Settings table skipped..... Reason: already exists";
               }else{
                 $db_2->create_table('settings');
                 $this->db->insert('settings', array(
                     'id'       => 100,
                     'fcm_server_key'      => "YOUR FIREBASE SERVER KEY",
                     'mail_username'   => "",
                     'mail_password'   => "",
                     'mail_smtp_host'   => "ssl://smtp.googlemail.com",
                     'mail_protocol'   => "smtp",
                     'mail_port'   => 465,
                 ));
                 echo "Settings table Created successfully";
               }
    }

    public function create_android_users_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Android Users table <br>";
      $db_3 = $this->dbforge;
      $db_3->add_field(array(
                       'id' => array(
                               'type' => 'INT',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),
                       'name' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'email' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'password' => array(
                               'type' => 'text',
                       ),
                       'login_type' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '100',
                               'default' => 'email',
                               'comment' => 'email,facebook,or google',
                       )
                       ,
                       'date' => array(
                               'type' => 'timestamp',
                       ),
                       'verified' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'blocked' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'isDeleted' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'user_coins' => array(
                               'type' => 'bigint',
                       ),
               ));
               $db_3->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_android_users')){
                 echo "Android Users table skipped..... Reason: already exists";
               }else{
                 $db_3->create_table('tbl_android_users');
                 echo "Android Users table Created successfully";
               }
    }

    public function create_fcm_token_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new FCM TOKEN table <br>";

      $db_4 = $this->dbforge;
      $db_4->add_field(array(
                       'id' => array(
                               'type' => 'INT',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),
                       'token' => array(
                         'type' => 'text'
                       ),
                       'app_version' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '10',
                         'default' => 'v1',
                       ),
                       'date' => array(
                         'type' => 'timestamp'
                       )
               ));
               $db_4->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_fcm_token')){
                 echo "FCM TOKEN table skipped..... Reason: already exists";
               }else{
                 $db_4->create_table('tbl_fcm_token');
                 echo "FCM TOKEN table Created successfully";
               }
    }

    public function create_media_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Media table <br>";
      $db_4 = $this->dbforge;

      $db_4->add_field(array(
                       'id' => array(
                               'type' => 'bigint',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),
                       'category' => array(
                               'type' => 'bigint'
                       ),
                       'sub_category' => array(
                               'type' => 'bigint'
                       ),
                       'title' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '300',
                       ),
                       'description' => array(
                         'type' => 'text',
                       ),
                       'cover_photo' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '100',
                       ),
                       'source' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '100',
                       ),
                       'duration' => array(
                               'type' => 'bigint',
                       ),
                       'amount' => array(
                               'type' => 'bigint',
                       ),
                       'can_preview' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'preview_duration' => array(
                               'type' => 'bigint',
                               'comment' => 'in seconds',
                       ),
                       'can_download' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'is_free' => array(
                               'type' => 'int',
                               'constraint' => '1',
                               'default' => '1',
                               'comment' => '0 for true, 1 for false',
                       ),
                       'type' => array(
                               'type' => 'varchar',
                               'constraint' => '10',
                       ),
                       'video_type' => array(
                               'type' => 'varchar',
                               'constraint' => '100',
                               'default' => 'mp4_video',
                       ),
                       'likes_count' => array(
                               'type' => 'bigint',
                               'default' => '0',
                       ),
                       'views_count' => array(
                         'type' => 'bigint',
                         'default' => '0',
                       ),
                       'dateInserted' => array(
                               'type' => 'timestamp',
                       ),
               ));
               $db_4->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_media')){
                 echo "Media table skipped..... Reason: already exists";
               }else{
                 $db_4->create_table('tbl_media');
                 echo "Media table Created successfully";
               }
    }

    public function create_verification_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Email Verification table <br>";
      $db_6 = $this->dbforge;
      $db_6->add_field(array(
                       'id' => array(
                               'type' => 'INT',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),
                       'email' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '100',
                       ),
                       'activation_id' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '32',
                       ),
                       'agent' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '512',
                       ),
                       'client_ip' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '50',
                       ),
                       'createdDtm' => array(
                               'type' => 'datetime'
                       ),
               ));
               $db_6->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_verification')){
                 echo "Email Verification table skipped..... Reason: already exists";
               }else{
                 $db_6->create_table('tbl_verification');
                 echo "Email Verification table Created successfully";
               }
    }

    public function create_comments_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Comments table <br>";
      $db_7 = $this->dbforge;

      $db_7->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'media_id' => array(
                         'type' => 'bigint',
                         'default' => 0,
                       ),
                       'comment_id' => array(
                         'type' => 'bigint',
                         'default' => 0,
                       ),
                       'email' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'content' => array(
                         'type' => 'text',
                       ),
                       'type' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '50',
                       ),
                       'date' => array(
                          'type' => 'bigint',
                       ),
                       'edited' => array(
                         'type' => 'int',
                         'default' => 1,
                       ),
                       'deleted' => array(
                         'type' => 'int',
                         'default' => 1,
                       ),
               ));
               $db_7->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_comments')){
                 echo "Comments table skipped..... Reason: already exists";
               }else{
                 $db_7->create_table('tbl_comments');
                 echo "Comments table Created successfully";
               }
    }

    public function create_reports_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Reports table <br>";
      $db_8 = $this->dbforge;

      $db_8->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'comment_id' => array(
                         'type' => 'bigint'
                       ),
                       'email' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                      'type' => array(
                       'type' => 'VARCHAR',
                       'constraint' => '10',
                       ),
                       'reason' => array(
                        'type' => 'VARCHAR',
                        'constraint' => '100',
                        ),
                       'date' => array(
                          'type' => 'bigint',
                       ),
               ));
               $db_8->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_reported_comments')){
                 echo "Replies Reports skipped..... Reason: already exists";
               }else{
                 $db_8->create_table('tbl_reported_comments');
                 echo "Reports table Created successfully";
               }
    }

    public function create_media_likes_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Media Likes table <br>";
      $db_9 = $this->dbforge;

      $db_9->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'media_id' => array(
                         'type' => 'bigint'
                       ),
                       'email' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'date' => array(
                          'type' => 'bigint',
                       ),
               ));
               $db_9->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_media_likes')){
                 echo "Media Likes table skipped..... Reason: already exists";
               }else{
                 $db_9->create_table('tbl_media_likes');
                 echo "Media Likes table Created successfully";
               }
    }

    public function create_categories_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Categories table <br>";
      $db_10 = $this->dbforge;

      $db_10->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'name' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'thumbnail' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
               ));
               $db_10->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_categories')){
                 echo "Categories table skipped..... Reason: already exists";
               }else{
                 $db_10->create_table('tbl_categories');
                 echo "Categories table Created successfully";
               }
    }

    public function create_sub_categories_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Sub Categories table <br>";
      $db_10 = $this->dbforge;

      $db_10->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'category_id' => array(
                           'type' => 'bigint'
                       ),
                       'name' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
               ));
               $db_10->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_sub_categories')){
                 echo "Categories table skipped..... Reason: already exists";
               }else{
                 $db_10->create_table('tbl_sub_categories');
                 echo "Categories table Created successfully";
               }
    }

    public function create_livestream_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new LiveStreams table <br>";
      $db_10 = $this->dbforge;

      $db_10->add_field(array(
                       'id' => array(
                           'type' => 'bigint',
                           'unsigned' => TRUE,
                           'auto_increment' => TRUE
                       ),
                       'title' => array(
                         'type' => 'text'
                       ),
                       'stream_url' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'type' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '200',
                       ),
                       'status' => array(
                         'type' => 'int',
                         'default' => 1,
                         'comment' => '0 for true, 1 for false',
                       ),
               ));
               $db_10->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_streaming')){
                 echo "LiveStreams table skipped..... Reason: already exists";
               }else{
                 $db_10->create_table('tbl_streaming');
                 $this->db->insert('tbl_streaming', array(
                     'id'       => 100,
                     'title'      => "",
                     'stream_url'   => ""
                 ));
                 echo "LiveStreams table Created successfully";
               }
    }


    public function create_devotionals_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Devotionals table <br>";
      $db_4 = $this->dbforge;

      $db_4->add_field(array(
                       'id' => array(
                               'type' => 'bigint',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),

                       'title' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'author' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '100',
                       ),
                       'content' => array(
                         'type' => 'longtext'
                       ),
                       'bible_reading' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'confession' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '1000',
                       ),
                       'studies' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'date' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
               ));
               $db_4->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_devotionals')){
                 echo "Devotionals table skipped..... Reason: already exists";
               }else{
                 $db_4->create_table('tbl_devotionals');
                 echo "Devotionals table Created successfully";
               }
    }

    public function create_events_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Events table <br>";
      $db_4 = $this->dbforge;

      $db_4->add_field(array(
                       'id' => array(
                               'type' => 'bigint',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),

                       'title' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'details' => array(
                         'type' => 'longtext'
                       ),
                       'thumbnail' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'time' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
                       'date' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '500',
                       ),
               ));
               $db_4->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_events')){
                 echo "Events table skipped..... Reason: already exists";
               }else{
                 $db_4->create_table('tbl_events');
                 echo "Events table Created successfully";
               }
    }

    public function create_inbox_table(){
      echo "<br><br>";
      echo ".......................................................................................<br>";
      echo "Create new Inbox table <br>";
      $db_4 = $this->dbforge;

      $db_4->add_field(array(
                       'id' => array(
                               'type' => 'bigint',
                               'unsigned' => TRUE,
                               'auto_increment' => TRUE
                       ),

                       'title' => array(
                         'type' => 'VARCHAR',
                         'constraint' => '100',
                       ),
                       'message'  => array(
                         'type' => 'VARCHAR',
                         'constraint' => '1000',
                       ),
                       'date' => array(
                               'type' => 'bigint',
                       ),
               ));
               $db_4->add_key('id', TRUE);
               if ($this->db->table_exists('tbl_inbox')){
                 echo "Inbox table skipped..... Reason: already exists";
               }else{
                 $db_4->create_table('tbl_inbox');
                 echo "Inbox table Created successfully";
               }
          }

          public function create_radio_table(){
            echo "<br><br>";
            echo ".......................................................................................<br>";
            echo "Create new Radio table <br>";
            $db_10 = $this->dbforge;

            $db_10->add_field(array(
                             'id' => array(
                                 'type' => 'bigint',
                                 'unsigned' => TRUE,
                                 'auto_increment' => TRUE
                             ),
                             'title' => array(
                               'type' => 'text'
                             ),
                             'thumbnail' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),
                             'stream_url' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '200',
                             ),
                     ));
                     $db_10->add_key('id', TRUE);
                     if ($this->db->table_exists('tbl_radio')){
                       echo "Radio table skipped..... Reason: already exists";
                     }else{
                       $db_10->create_table('tbl_radio');
                       $this->db->insert('tbl_radio', array(
                           'id'       => 100,
                           'title'      => "",
                           'thumbnail'      => "",
                           'stream_url'   => ""
                       ));
                       echo "Radio table Created successfully";
                     }
          }

          public function create_coins_table(){
            echo "<br><br>";
            echo ".......................................................................................<br>";
            echo "Create new Coins table <br>";
            $db_10 = $this->dbforge;

            $db_10->add_field(array(
                             'id' => array(
                                 'type' => 'bigint',
                                 'unsigned' => TRUE,
                                 'auto_increment' => TRUE
                             ),

                             'name' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),
                             'description' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),
                             'amount' => array(
                               'type' => 'int'
                             ),
                             'value' => array(
                               'type' => 'int'
                             ),
                     ));
                     $db_10->add_key('id', TRUE);
                     if ($this->db->table_exists('tbl_coins')){
                       echo "Coins table skipped..... Reason: already exists";
                     }else{
                       $db_10->create_table('tbl_coins');
                       echo "Coins table Created successfully";
                     }
          }

          public function create_coins_purchases_table(){
            echo "<br><br>";
            echo ".......................................................................................<br>";
            echo "Create new Coins Purchases table <br>";
            $db_10 = $this->dbforge;

            $db_10->add_field(array(
                             'id' => array(
                                 'type' => 'bigint',
                                 'unsigned' => TRUE,
                                 'auto_increment' => TRUE
                             ),

                             'email' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),
                             'reference' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),
                             'amount' => array(
                               'type' => 'int'
                             ),
                             'coin_id' => array(
                               'type' => 'int'
                             ),
                             'date' => array(
                               'type' => 'timestamp'
                             )
                     ));
                     $db_10->add_key('id', TRUE);
                     if ($this->db->table_exists('tbl_coin_purchases')){
                       echo "Coins Purchases table skipped..... Reason: already exists";
                     }else{
                       $db_10->create_table('tbl_coin_purchases');
                       echo "Coins Purchases table Created successfully";
                     }
          }

          public function create_media_purchases_table(){
            echo "<br><br>";
            echo ".......................................................................................<br>";
            echo "Create new Media Purchases table <br>";
            $db_10 = $this->dbforge;

            $db_10->add_field(array(
                             'id' => array(
                                 'type' => 'bigint',
                                 'unsigned' => TRUE,
                                 'auto_increment' => TRUE
                             ),

                             'email' => array(
                               'type' => 'VARCHAR',
                               'constraint' => '500',
                             ),

                             'media_id' => array(
                               'type' => 'bigint'
                             ),
                             'date' => array(
                               'type' => 'timestamp'
                             )
                     ));
                     $db_10->add_key('id', TRUE);
                     if ($this->db->table_exists('tbl_media_purchases')){
                       echo "Media Purchases table skipped..... Reason: already exists";
                     }else{
                       $db_10->create_table('tbl_media_purchases');
                       echo "Media Purchases table Created successfully";
                     }
          }

 }
