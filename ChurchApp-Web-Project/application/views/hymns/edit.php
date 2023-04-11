<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Edit Devotional</h2>
        </div>


            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>editHymnData" enctype="multipart/form-data" style="margin-top:30px;">
                            <input type="hidden" class="form-control" name="id"  value="<?php echo $hymn->id; ?>">


                            <div class="input-group addon-line">
                                <label>Hymn/Worship Lyrics CoverPhoto (Leave empty to use app default image)</label>
                                <div class="form-line">
                                    <input data-default-file="<?php echo $hymn->thumbnail; ?>" type="file" name="thumbnail" data-allowed-file-extensions="png jpg jpeg PNG" class="thumbs_dropify" required>
                                </div>
                            </div>



                            <div class="input-group addon-line" style="margin-top:20px;">
                                 <label>Hymn/Worship Lyrics Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="Hymn or Worship Lyrics Title" required="" autofocus="" value="<?php echo $hymn->title; ?>">
                                </div>
                            </div>



                            <div class="input-group addon-line" style="margin-top:30px;">
                                  <label>Hymn/Worship Lyrics Content</label>
                                <div class="form-line">
                                  <textarea class="editor" name="content"><?php echo $hymn->content; ?></textarea>
                                </div>
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
                               <button class="btn btn-primary waves-effect" type="submit">Edit</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
