<section class="content">
  <div class="container-fluid">
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                      <div class="card-header" style="padding: 15px 15px 15px 15px;">
                           <h2>Update LiveStreams</h2>
                           <h6>Manually activate or deactivate a livestream. Users will be able subscribe and watch an active livestream. </h6>
                           <h6>You have to set a livestream status to inactive when the livestream is finished or you dont want users to watch the livestream.</h6>
                       </div>

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>updateLiveStreams">

                            <div class="input-group addon-line" style="margin-top:10px;">
                                <label>LiveStream Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="" required="" autofocus="" value="<?php echo $streams->title; ?>">
                                </div>
                            </div>
                            <div class="addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                  <label>LiveTv Source</label>
                                    <select class="form-control" name="type" required="" autofocus="">
                                        <option value="rtmp" <?php echo $streams->type=="rtmp"?"selected":""; ?>>rtmp Live</option>
                                        <option value="youtube" <?php echo $streams->type=="youtube"?"selected":""; ?>>Youtube LiveVideo ID</option>
                                        <option value="m3u8" <?php echo $streams->type=="m3u8"?"selected":""; ?>>m3u8 Live</option>
                                    </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Stream URL OR ID</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="stream_url" placeholder="" autofocus="" value="<?php echo $streams->stream_url; ?>">
                                </div>
                            </div>


                            <div class="addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                  <label>LiveStream Status</label>
                                    <select class="form-control" name="status" required="" autofocus="">
                                        <option value="0" <?php echo $streams->status==0?"selected":""; ?>>Active</option>
                                        <option value="1" <?php echo $streams->status==1?"selected":""; ?>>InActive</option>
                                    </select>
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
