<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Update Settings</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>updateSettings">


                            <div class="input-group addon-line">
                                <label>Firebase Server Key</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="fcm_server_key" placeholder="" autofocus="" value="<?php echo $settings->fcm_server_key; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Ads Interval(How often in minutes will the users be shown an ad)</label>
                                <div class="form-line">
                                    <input type="number" class="form-control" name="ads_interval" placeholder="Adverts interval in minutes" autofocus="" value="<?php echo $settings->ads_interval; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:10px;">
                                <label>Website URL (Link to your existing church website url)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="website_url" placeholder="" autofocus="" value="<?php echo $settings->website_url; ?>">
                                </div>
                            </div>

                            <h4 style="margin-top:40px;">The following images are used on the apps homepage.</h4>

                            <div class="input-group addon-line" style="margin-top:40px;">
                                <label>Image Shown for Audio & Video Messages (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="url" class="form-control" name="image_one" placeholder="" value="<?php echo $settings->image_one; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown For Notes (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="url" class="form-control" name="image_two" placeholder="" value="<?php echo $settings->image_two; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for bible (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="url" class="form-control" name="image_three" placeholder="" value="<?php echo $settings->image_three; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for Livestreams (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="url" class="form-control" name="image_four" placeholder="" value="<?php echo $settings->image_four; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for radio (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="image_five" placeholder="" value="<?php echo $settings->image_five; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for devotionals (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="url" class="form-control" name="image_six" placeholder="" value="<?php echo $settings->image_six; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for Hymns/Worship (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="image_seven" placeholder="" value="<?php echo $settings->image_seven; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Image Shown for donate (Leave empty to use app default)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="image_eight" placeholder="" value="<?php echo $settings->image_eight; ?>">
                                </div>
                            </div>



                            <h4 style="margin-top:40px;">Your Social Profile Pages.</h4>
                            <div class="input-group addon-line">
                                <label>Facebook Page</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="facebook_page" placeholder="" autofocus="" value="<?php echo $settings->facebook_page; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Youtube Page</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="youtube_page" placeholder="" autofocus="" value="<?php echo $settings->youtube_page; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Twitter Page</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="twitter_page" placeholder="" autofocus="" value="<?php echo $settings->twitter_page; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>Instagram Page</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="instagram_page" placeholder="" autofocus="" value="<?php echo $settings->instagram_page; ?>">
                                </div>
                            </div>

                            <h4 style="margin-top:40px;">SMTP & mail configuration(The fields below will be used to send mail to users)</h4>

                            <div class="input-group addon-line" style="margin-top:10px;">
                                <label>SMTP username</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="mail_username" placeholder="" required="" autofocus="" value="<?php echo $settings->mail_username; ?>">
                                </div>
                            </div>
                            <div class="input-group addon-line">
                                <label>SMTP password</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="mail_password" placeholder="" autofocus="" value="<?php echo $settings->mail_password; ?>">
                                </div>
                            </div>


                            <div class="input-group addon-line">
                                <label>SMTP HOST</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="mail_smtp_host" placeholder="" autofocus="" value="<?php echo $settings->mail_smtp_host; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line col-md-6">
                                <label>SMTP Protocol</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="mail_protocol" placeholder="" autofocus="" value="<?php echo $settings->mail_protocol; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line col-md-6">
                                <label>TCP port to connect to</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="mail_port" placeholder="" autofocus="" value="<?php echo $settings->mail_port; ?>">
                                </div>
                            </div>


                             <?php $this->load->helper('form'); ?>
                             <div class="row">
                                 <div class="col-md-12">
                                     <?php echo validation_errors('<div class="alert alert-danger alert-dismissable">', ' <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button></div>'); ?>
                                 </div>
                             </div>
                             <?php
                             $this->load->helper('form');
                             $error = $this->session->flashdata('error');
                             if($error)
                             {
                                 ?>
                                 <div class="alert alert-danger alert-dismissable">
                                     <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                     <?php echo $error; ?>
                                 </div>
                             <?php }
                             $success = $this->session->flashdata('success');
                             if($success)
                             {
                                 ?>
                                 <div class="alert alert-success alert-dismissable">
                                     <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                     <?php echo $success; ?>
                                 </div>
                             <?php } ?>

                            <div class="box-footer text-center">
                               <button class="btn btn-primary waves-effect" type="submit">UPDATE SETTINGS</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
            </div>
    </div>
</section>
