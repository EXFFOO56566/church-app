<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Send Notification to Android users</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>sendNotification">
                            <div class="input-group addon-line">
                                <label>Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="" required="" autofocus="">
                                </div>
                            </div>
                            <div class="input-group addon-line">
                                <label>Message</label>
                                <div class="form-line">
                                    <textarea cols="100" type="text" class="form-control" name="message" placeholder="" required="" autofocus=""></textarea>
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
                               <button class="btn btn-primary waves-effect" type="submit">SEND NOTIFICATION</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
    </div>
</section>

<!-- FOOTER-->
<footer>
    <span>&copy; <?php echo $this->session->userdata ( 'site_name' ); ?> <b class="col-blue">Admin</b></span>
</footer>
</div>
