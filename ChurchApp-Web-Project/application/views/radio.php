<section class="content">
  <div class="container-fluid">
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                      <div class="card-header" style="padding: 15px 15px 15px 15px;">
                           <h2>Update Radio Channel</h2>
                       </div>

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>updateRadio">

                            <div class="input-group addon-line" style="margin-top:10px;">
                                <label>Radio Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="" required="" autofocus="" value="<?php echo $radio->title; ?>">
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:10px;">
                                <label>Radio CoverPhoto</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="thumbnail" placeholder="" required="" autofocus="" value="<?php echo $radio->thumbnail; ?>">
                                </div>
                            </div>
                            <div class="input-group addon-line">
                                <label>Radio Stream URL</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="stream_url" placeholder="" autofocus="" value="<?php echo $radio->stream_url; ?>">
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
                               <button class="btn btn-primary waves-effect" type="submit">UPDATE</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
    </div>
  </div>
</section>
