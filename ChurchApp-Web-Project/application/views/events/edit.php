<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Update Event Data</h2>
        </div>

    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>editEventData" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<?php echo $event->id; ?>">
                            <div class="input-group addon-line">
                                 <label>Event Date</label>
                                <div class="form-line">
                                    <input type="datetime" class="form-control" name="date" placeholder="Feed Date" required="" value="<?php echo $event->date; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                 <label>Event Time</label>
                                <div class="form-line">
                                    <input type="time" class="form-control" name="time" placeholder="Event Date" required="" value="<?php echo $event->time; ?>">
                                </div>
                            </div>


                            <div class="input-group addon-line">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="event Title" required="" autofocus="" value="<?php echo $event->title; ?>">
                                </div>
                            </div>
                            <div class="input-group addon-line">

                                <div class="form-line">
                                    <input data-default-file="<?php echo $event->thumbnail; ?>" type="file" name="thumbnail" data-allowed-file-extensions="png jpg jpeg PNG" class="thumbs_dropify">
                                </div>
                            </div>



                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Event Details</label>
                                <div class="form-line">
                                  <textarea class="editor" name="details"><?php echo $event->details; ?></textarea>
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
                               <button class="btn btn-primary waves-effect" type="submit">UPDATE EVENT</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
