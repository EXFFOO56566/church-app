var obUrl;

//function to load url for deleting respective items from database
function delete_item(e){
  var id = e.target.getAttribute('data-id');
  var type = e.target.getAttribute('data-type');
  var msg = '';
  var url = '';

  switch(type){
    case 'coupon':
       var msg = 'You want to delete this coupon code';
       url = baseURL+'deleteCoupon/'+id;
    break;
    case 'bible':
       var msg = 'You want to delete this bible version';
       url = baseURL+'deleteBible/'+id;
    break;
    case 'branch':
       var msg = 'You want to delete this church branch';
       url = baseURL+'deleteBranch/'+id;
    break;
    case 'hymns':
       var msg = 'You want to delete this hymn/worship lyrics data';
       url = baseURL+'deleteHymn/'+id;
    break;
    case 'coins':
       var msg = 'You want to delete this Coins data';
       url = baseURL+'deleteCoins/'+id;
    break;
    case 'music':
       var msg = 'You want to delete this Music File';
       url = baseURL+'deleteMusic/'+id;
    break;
    case 'inbox':
       var msg = 'You want to delete this Message';
       url = baseURL+'deleteInbox/'+id;
    break;
    case 'events':
       var msg = 'You want to delete this Event';
       url = baseURL+'deleteEvent/'+id;
    break;
    case 'radio':
       var msg = 'You want to delete this Radio Channel';
       url = baseURL+'deleteRadioLink/'+id;
       break;
    case 'admin':
       var msg = 'You want to delete this Admin User';
       url = baseURL+'deleteAdmin/'+id;
    break;
    case 'audio':
       var msg = 'You want to delete this Audio File';
       url = baseURL+'deleteAudio/'+id;
    break;
    case 'video':
       var msg = 'You want to delete this Video File';
       url = baseURL+'deleteVideo/'+id;
    break;
    case 'reports':
       var msg = 'You want to delete this reported comment';
       url = baseURL+'deleteReport/'+id;
    break;
    case 'category':
       var msg = 'You want to delete this category';
       url = baseURL+'deleteCategory/'+id;
    break;
    case 'ebook':
       var msg = 'You want to delete this ebook';
       url = baseURL+'deleteEbook/'+id;
    break;
    case 'devotionals':
       var msg = 'You want to delete this devotional';
       url = baseURL+'deleteDevotional/'+id;
    break;
    case 'subcategory':
       var msg = 'You want to delete this subcategory';
       url = baseURL+'deleteSubCategory/'+id;
    break;
    case 'livestream':
       var msg = 'You want to delete this livestream';
       url = baseURL+'deleteLivestream/'+id;
    break;

  }
   swal({
     title: 'Are you sure?',
     text: msg,
     type: 'warning',
     confirmButtonColor: "#DD6B55",
     showCancelButton: true,
     confirmButtonText: 'Sure'
   },function () {
       document.location.href = url;
   });
}


function user_action(e){
  var id = e.target.getAttribute('data-id');
  var action = e.target.getAttribute('data-action');
  var blocked = e.target.getAttribute('data-blocked');
  console.log(action);
  var msg = '';
  var url = '';

  switch(action){
    case 'block':
       if(blocked==1){
         msg = 'You want to block this User';
         url = baseURL+'blockUser/'+id;
       }else{
         msg = 'You want to unblock this User';
         url = baseURL+'unBlockUser/'+id;
       }

    break;
    case 'delete':
       msg = 'You want to delete this User';
       url = baseURL+'deleteUser/'+id;
    break;
  }
   swal({
     title: 'Are you sure?',
     text: msg,
     type: 'warning',
     confirmButtonColor: "#DD6B55",
     showCancelButton: true,
     confirmButtonText: 'Sure'
   },function () {
       document.location.href = url;
   });
}

$('#purchases_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"coinspurchaseslisting",
        type : 'POST'
    },
    dom: 'frtip'
});


$('#donations_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"donationslisting",
        type : 'POST'
    },
    dom: 'frtip'
});

function comment_action(e){
  var id = e.target.getAttribute('data-id');
  var action = e.target.getAttribute('data-action');
  var deleted = e.target.getAttribute('data-deleted');
  console.log(action);
  var msg = '';
  var url = '';

  switch(action){
    case 'publish':
       if(deleted==1){
         msg = 'You want to unpublish this comment, users wont be able to see this comment if you unpublish.';
         url = baseURL+'unPublishComment/'+id;
       }else{
         msg = 'You want to publish this comment, users will be able to see this comment if you publish.';
         url = baseURL+'publishComment/'+id;
       }

    break;
    case 'delete':
       msg = 'You want to completely thrash this comment and all corresponding replies, this action cannot be undone.';
       url = baseURL+'thrashUserComment/'+id;
    break;
  }
   swal({
     title: 'Are you sure?',
     text: msg,
     type: 'warning',
     confirmButtonColor: "#DD6B55",
     showCancelButton: true,
     confirmButtonText: 'Sure'
   },function () {
       document.location.href = url;
   });
}

$('.thumbs_dropify').dropify({
    messages: {
        'default': 'Drag or drop thumbnail here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Ooops, something wrong happended.'
    }
});

$('.bible_dropify').dropify({
    messages: {
        'default': 'Drag or drop bible json file here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Ooops, something wrong happended.'
    }
});

$('.pdf_dropify').dropify({
    messages: {
        'default': 'Drag or drop PDF File here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Ooops, something wrong happended.'
    }
});

//initialise dropify for song upload
$('.dropify').dropify({
    messages: {
        'default': 'Drag or drop mp3 here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Select only mp3 files.'
    }
});

//initialise dropify for image upload
$('.dropify2').dropify({
    messages: {
        'default': 'Drag or drop cover photo here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Select only jpeg|jpg|png|JPEG|PNG image files.'
    }
});

//initialise dropify for video upload
$('.dropify3').dropify({
    messages: {
        'default': 'Drag or drop mp4 here',
        'replace': 'Drag and drop or click to replace',
        'remove':  'Remove',
        'error':   'Select only mp4 files.'
    }
});


$('#categories-table').DataTable({
    "pageLength" : 20,
    dom: 'frtip'
});

$('#reports_table').DataTable({
    "pageLength" : 20,
    dom: 'frtip'
});

$('#admin_table').DataTable({
    "pageLength" : 20,
    dom: 'frtip'
});

$('#users_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 20,
    "ajax": {
        url : baseURL+"getUsersAjax",
        type : 'POST'
    },
    dom: 'frtip'
});

$('#devotionals_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"getDevotionals",
        type : 'POST'
    },
    dom: 'frtip'
});

$('#hymns_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"getHymns",
        type : 'POST'
    },
    dom: 'frtip'
});

//initialise audios data table
//items are fetched through ajax
$('#audios_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"fetchAudios",
        type : 'POST'
    },
    dom: 'frtip',
    "columnDefs": [
    { className: "td_width", "targets": [ 0,1,2,3,4 ] }
  ]
});

$('#music_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"fetchMusic",
        type : 'POST'
    },
    dom: 'frtip',
    "columnDefs": [
    { className: "td_width", "targets": [ 0,1,2,3,4 ] }
  ]
});

//initialise videos data table
//items are fetched through ajax
$('#videos_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"fetchVideos",
        type : 'POST'
    },
    dom: 'frtip',
    "columnDefs": [
    { className: "td_width", "targets": [ 0,1,2,3,4 ] }
  ]
});

function error_alert(msg){
  swal({
    title: 'Error!',
    text: msg,
    type: 'warning',
    confirmButtonClass: 'btn btn-success'
  });
}

function success_alert(msg){
  swal({
    title: 'Success!',
    text: msg,
    type: 'success',
    confirmButtonClass: 'btn btn-success'
  });
}


//upload new audio file
function uploadNewAudio(event){
  event.preventDefault();
  var category = $('#category').selectpicker('val');
  var subcategory = $('#subcategories').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var duration = $("#duration").val();
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var notify = $('#notify').selectpicker('val');
  var media_type = $('#audio_type').selectpicker('val');
  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the audio file');
    return;
  }

  if(title == ""){
    error_alert('Please add title for the audio file');
    return;
  }

  if(media_type!= 0 && !isValidURL(thumbnail_link)){
    error_alert('Provide a valid thumbnail link for the media file.');
    return;
   }

   if(media_type!= 0 && media_link==""){
     error_alert('Provide a valid Audio link.');
     return;
    }

    if(duration == ""){
      error_alert('Please add duration for this Audio');
      return;
    }

    var form_obj = JSON.stringify({
      category: category,
      subcategory: subcategory,
      title: title.trim(),
      description: description.trim(),
      thumbnail_link: thumbnail_link,
      media_type: media_type,
      media_link: media_link,
      duration:duration,
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      notify: notify
    });

    var fd = new FormData();
    fd.append("data", form_obj);

    var thumbnail = document.getElementById('thumbnail');
    var _thumbnail = thumbnail.files[0];
    if(_thumbnail==undefined && media_type== 0){
      error_alert('Please select a cover photo for this audio file.');
      return;
    }else if(_thumbnail!=undefined && media_type== 0){
        fd.append("thumbnail", _thumbnail);
    }

    var audio = document.getElementById('audio-file');
    var _audio = audio.files[0];
    if(_audio==undefined && media_type== 0){
      error_alert('Please select an mp3 file to upload.');
      return;
    }else if(_audio!=undefined && media_type== 0){
        fd.append("audio", _audio);
    }
    show_loader();
    makeAjaxCall( baseURL+"saveNewAudio", "POST",fd).then(processResponse,  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}

//update uploaded audio file
function updateAudio(event){
  event.preventDefault();
  var category = $('#category').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var subcategory = $('#subcategories').selectpicker('val');
  var duration = $("#duration").val();
  var id = $("#id").val();

  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the audio file');
    return;
  }

  if(title == ""){
    error_alert('Please add title for the audio file');
    return;
  }

  if(thumbnail_link==""){
    error_alert('Audio cover photo cannot be left empty.');
    return;
  }

  if(media_link==""){
    error_alert('Audio FIle Field cannot be left empty.');
    return;
  }


    if(duration == ""){
      error_alert('Please add duration for this audio');
      return;
    }

  //var audio = document.getElementById('audio-file');
  //var _audio = audio.files[0];

    show_loader();
    var form_obj = JSON.stringify({
      id:id,
      category: category,
      title:title.trim(),
      description: description.trim(),
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      subcategory: subcategory,
      duration:duration
    });
    //console.log(form_obj); return;
    var fd = new FormData();
    fd.append("data", form_obj);

    makeAjaxCall( baseURL+"editAudioData", "POST",fd).then(function(data){
      hide_loader();
      console.log("render user details", data);
      if(data.status == "ok"){
        success_alert(data.msg);
      }else{
         error_alert(data.msg);
      }
    },  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}


//upload new video file
function uploadNewVideo(event){
  event.preventDefault();
  var category = $('#category').selectpicker('val');
  var subcategory = $('#subcategories').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var duration = $("#duration").val();
  var notify = $('#notify').selectpicker('val');
  var media_type = $('#media_type').selectpicker('val');
  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the video file');
    return;
  }


  if(title == ""){
    error_alert('Please add title for the video file');
    return;
  }

  if(media_type!= "mp4_video" && !isValidURL(thumbnail_link)){
    error_alert('Provide a valid thumbnail link for the media file.');
    return;
   }

   if(media_type!= "mp4_video" && media_link==""){
     switch(media_type){
       case "video_link":
         error_alert('Provide a valid mp4 video link.');
       break;
       case "mpd_video":
         error_alert('Provide a valid mpd video link.');
       break;
       case "m3u8_video":
         error_alert('Provide a valid m3u8 video link.');
       break;
       case "youtube_video":
         error_alert('Provide a valid Youtube video id.');
       break;
       case "vimeo_video":
         error_alert('Provide a valid Vimeo video id.');
       break;
       case "dailymotion_video":
         error_alert('Provide a valid DailyMotion video id.');
       break;
     }
     return;
    }

    if(duration == ""){
      error_alert('Please add duration for this video');
      return;
    }

    var form_obj = JSON.stringify({
      category: category,
      subcategory: subcategory,
      title: title.trim(),
      description: description.trim(),
      thumbnail_link: thumbnail_link,
      media_type: media_type,
      media_link: media_link,
      duration:duration,
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      notify: notify
    });

    var fd = new FormData();
    fd.append("data", form_obj);

    var thumbnail = document.getElementById('thumbnail');
    var _thumbnail = thumbnail.files[0];
    if(_thumbnail==undefined && media_type== "mp4_video"){
      error_alert('Please select a cover photo for this video file.');
      return;
    }else if(_thumbnail!=undefined && media_type== "mp4_video"){
        fd.append("thumbnail", _thumbnail);
    }

    var video = document.getElementById('video-file');
    var _video = video.files[0];
    if(_video==undefined && media_type== "mp4_video"){
      error_alert('Please select an mp4 file to upload.');
      return;
    }else if(_video!=undefined && media_type== "mp4_video"){
        fd.append("video", _video);
    }


    //console.log(fd); return;
    show_loader();
    makeAjaxCall( baseURL+"saveNewVideo", "POST",fd).then(processResponse,  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}

//update uploaded video file
function updateVideo(event){
  event.preventDefault();
  var form = document.getElementById('upload-form');
  var category = $('#category').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var subcategory = $('#subcategories').selectpicker('val');
  var duration = $("#duration").val();
  var id = $("#id").val();

  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the video file');
    return;
  }

  if(title == ""){
    error_alert('Please add title for the video file');
    return;
  }

    if(duration == ""){
      error_alert('Please add duration for this video');
      return;
    }

    if(thumbnail_link==""){
      error_alert('Video cover photo cannot be left empty.');
      return;
    }

    if(media_link==""){
      error_alert('Video File field cannot be left empty.');
      return;
    }
    show_loader();
    var form_obj = JSON.stringify({
      id:id,
      category: category,
      title:title.trim(),
      description: description.trim(),
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      subcategory: subcategory,
      duration:duration
    });
    //console.log(form_obj); return;
    var fd = new FormData();
    fd.append("data", form_obj);

    makeAjaxCall( baseURL+"editVideoData", "POST",fd).then(function(data){
      hide_loader();
      console.log("render user details", data);
      if(data.status == "ok"){
        success_alert(data.msg);
      }else{
         error_alert(data.msg);
      }
    },  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}

function processResponse(data){
  hide_loader();
  console.log("render user details", data);
  if(data.status == "ok"){
    success_alert(data.msg);
    //clear form elements
    //clear form elements
    $("#title").val("");
    $("#description").val("");
    $("#duration").val("");

    //clear dropify elements
    $('.dropify-clear').click();
    $('.dropify2-clear').click();
    $('.dropify3-clear').click();

  }else{
     error_alert(data.msg);
  }
}

function show_loader(){
  var submit = document.getElementById('submit');
  var loader = document.getElementById('loader');
  if(submit!=undefined){
    submit.style.display='none';
  }
  if(loader!=undefined){
    loader.style.display='block';
  }
}

function hide_loader(){
  var submit = document.getElementById('submit');
  var loader = document.getElementById('loader');
  if(submit!=undefined){
    submit.style.display='block';
  }
  if(loader!=undefined){
    loader.style.display='none';
  }
}

//listener to check if an audio file was playing
//then pause it
document.addEventListener('play', function(e){
    var audios = document.getElementsByTagName('audio');
    for(var i = 0, len = audios.length; i < len;i++){
        if(audios[i] != e.target){
            audios[i].pause();
        }
    }
}, true);

function warn_user(evt){
  evt.preventDefault();
  var el = evt.target;
  var email = el.getAttribute('data-email');
  var comment = el.getAttribute('data-comment');

  swal({
  title: "",
  text: "Block Alert Warning",
  type: "input",
  showCancelButton: true,
  closeOnConfirm: false,
  animation: "slide-from-top",
  inputPlaceholder: "Warn user of consquences of making such comments",
  showLoaderOnConfirm: true
},
function(message){
  if (message === false) return false;

  if (message === "") {
    swal.showInputError("You need to write something!");
    return false;
  }

  show_loader();
  var form_obj = JSON.stringify({
    email:email,
    comment: comment,
    message: message
  });
  //console.log(form_obj); return;
  var fd = new FormData();
  fd.append("data", form_obj);

  makeAjaxCall( baseURL+"reportedCommentWarnEmail", "POST",fd).then(function(response){
       if(data.status == "ok"){
         success_alert(data.msg);
       }else{
          error_alert(data.msg);
       }
  },  function(status){
     console.log("failed with status", status);
     error_alert("failed with status", status);
  });
});
}

function view_comments_by_date(){
  var date = document.getElementById('reportrange').value;
  if(date!=""){
    var res = date.split(" - ");
    if(res[0]== undefined || res[1] == undefined){
      error_alert("Selected date(s) is invalid!!");
      return;
    }
     var date1 = res[0];
     var date2 = res[1];
      load_comments(date1,date2);

  }
}

function load_comments(date1,date2){
  $('#comments_table').DataTable({
    "bDestroy": true,
    "bProcessing": true,
     "serverSide": true,
      "pageLength" : 20,
      "ajax": {
          url : baseURL+"getCommentsAjax?date="+date1+"&date2="+date2,
          type : 'POST'
      },
      dom: 'frtip'
  });
}
load_comments(0,0);

$("#audio_type").change(function(){
    var type = $('#audio_type option:selected').val();
    var upload_div = document.getElementById('upload_div');
    var link_div = document.getElementById('link_div');
    if(type==0){
       upload_div.style.display = 'block';
       link_div.style.display = 'none';
    }else{
      upload_div.style.display = 'none';
      link_div.style.display = 'block';
    }
});

$("#media_type").change(function(){
    var type = $('#media_type option:selected').val();
    var upload_div = document.getElementById('upload_div');
    var link_div = document.getElementById('link_div');
    if(type=="mp4_video"){
       upload_div.style.display = 'block';
       link_div.style.display = 'none';
    }else{
      upload_div.style.display = 'none';
      link_div.style.display = 'block';
      switch(type){
        case "video_link":
          $("#media_link").attr("placeholder", "Mp4 Video Link");
          $("#video-label").html("Enter Mp4 Video Link");
        break;
        case "mpd_video":
          $("#media_link").attr("placeholder", "Mpd Video Link");
          $("#video-label").html("Enter Mpd video link");
        break;
        case "m3u8_video":
          $("#media_link").attr("placeholder", "m3u8 video link");
          $("#video-label").html("Enter m3u8 video link");
        break;
        case "youtube_video":
          $("#media_link").attr("placeholder", "Youtube Video Id");
          $("#video-label").html("Enter Youtube Video Id");
        break;
        case "vimeo_video":
          $("#media_link").attr("placeholder", "Vimeo Video Id");
          $("#video-label").html("Enter Youtube Vimeo Id");
        break;
        case "dailymotion_video":
          $("#media_link").attr("placeholder", "DailyMotion Video Id");
          $("#video-label").html("Enter DailyMotion Video Id");
        break;
      }

    }
});

$("#category").change(function(){
    var selected = $('#category option:selected').val();
    console.log(selected);
    if(selected!=""){
      get_subcategories(selected);
    }

    var subcategories = document.getElementById('subcategories');
    subcategories.innerHTML = '<option value="">Select SubCategory</option>';
    $('#subcategories').selectpicker('refresh');
});

function get_subcategories(id){
  makeAjaxCall( baseURL+"loadsubcategories?id="+id, "POST",null).then(function(data){
       if(data.status == "ok"){
         var rows = data.subcategories;
         var subcategories = document.getElementById('subcategories');
         subcategories.innerHTML = '<option value="">Select SubCategory</option>';
         for(var i=0; i<rows.length; i++){
            subcategories.innerHTML += '<option value="'+rows[i]['id']+'">'+rows[i]['name']+'</option>';
         }
         $('#subcategories').selectpicker('refresh');
       }
  },  function(status){
     console.log("failed with status", status);
  });
}

function isValidURL(string) {
  var res = string.match(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g);
  if (res == null)
    return false;
  else
    return true;
};

$("#cat_group").change(function(){
    var cat_group = $('#cat_group option:selected').val();
    var categories = document.getElementById('category_id');
    categories.innerHTML = '<option value="">Select Category</option>';
    $('#category_id').selectpicker('refresh');
    if(cat_group=="")return;
    makeAjaxCall( baseURL+"loadcategories?cat_group="+cat_group, "GET",null).then(function(data){
         if(data.status == "ok"){
           var rows = data.categories;
           categories.innerHTML = '<option value="">Select Category</option>';
           for(var i=0; i<rows.length; i++){
              categories.innerHTML += '<option value="'+rows[i]['id']+'">'+rows[i]['name']+'</option>';
           }
           $('#category_id').selectpicker('refresh');
         }
    },  function(status){
       console.log("failed with status", status);
    });
});


function uploadNewSong(event){
  event.preventDefault();
  var category = $('#category').selectpicker('val');
  var subcategory = $('#subcategories').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var duration = $("#duration").val();
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var notify = $('#notify').selectpicker('val');
  var media_type = $('#audio_type').selectpicker('val');
  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the music file');
    return;
  }

  if(title == ""){
    error_alert('Please add title for the music file');
    return;
  }

  if(media_type!= 0 && !isValidURL(thumbnail_link)){
    error_alert('Provide a valid thumbnail link for the music file.');
    return;
   }

   if(media_type!= 0 && media_link==""){
     error_alert('Provide a valid music link.');
     return;
    }

    if(duration == ""){
      error_alert('Please add duration for this Music');
      return;
    }

    var form_obj = JSON.stringify({
      category: category,
      subcategory: subcategory,
      title: title.trim(),
      description: description.trim(),
      thumbnail_link: thumbnail_link,
      media_type: media_type,
      media_link: media_link,
      duration:duration,
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      notify: notify
    });

    var fd = new FormData();
    fd.append("data", form_obj);

    var thumbnail = document.getElementById('thumbnail');
    var _thumbnail = thumbnail.files[0];
    if(_thumbnail==undefined && media_type== 0){
      error_alert('Please select a cover photo for this music file.');
      return;
    }else if(_thumbnail!=undefined && media_type== 0){
        fd.append("thumbnail", _thumbnail);
    }

    var audio = document.getElementById('audio-file');
    var _audio = audio.files[0];
    if(_audio==undefined && media_type== 0){
      error_alert('Please select an mp3 file to upload.');
      return;
    }else if(_audio!=undefined && media_type== 0){
        fd.append("audio", _audio);
    }
    show_loader();
    makeAjaxCall( baseURL+"saveNewMusic", "POST",fd).then(processResponse,  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}

//update uploaded audio file
function updateSong(event){
  event.preventDefault();
  var category = $('#category').selectpicker('val');
  var title = $("#title").val();
  var description = $("#description").val();
  var is_free = $('#is_free').selectpicker('val');
  var can_download = $('#can_download').selectpicker('val');
  var can_preview = $('#can_preview').selectpicker('val');
  var _prv_duration = $("#preview_duration").val();
  var preview_duration = _prv_duration==""?0:_prv_duration;
  var subcategory = $('#subcategories').selectpicker('val');
  var duration = $("#duration").val();
  var id = $("#id").val();

  var thumbnail_link = $("#thumbnail_link").val();
  var media_link = $("#media_link").val();

  if(category == ""){
    error_alert('Please select category for the music file');
    return;
  }

  if(title == ""){
    error_alert('Please add title for the music file');
    return;
  }

  if(thumbnail_link==""){
    error_alert('Music cover photo cannot be left empty.');
    return;
  }

  if(media_link==""){
    error_alert('Music FIle Field cannot be left empty.');
    return;
  }


    if(duration == ""){
      error_alert('Please add duration for this music');
      return;
    }

  //var audio = document.getElementById('audio-file');
  //var _audio = audio.files[0];

    show_loader();
    var form_obj = JSON.stringify({
      id:id,
      category: category,
      title:title.trim(),
      description: description.trim(),
      is_free: is_free,
      can_download: can_download,
      can_preview: can_preview,
      preview_duration:preview_duration,
      subcategory: subcategory,
      duration:duration,
      thumbnail_link: thumbnail_link,
      media_link: media_link
    });
    //console.log(form_obj); return;
    var fd = new FormData();
    fd.append("data", form_obj);

    makeAjaxCall( baseURL+"editMusicData", "POST",fd).then(function(data){
      hide_loader();
      console.log("render user details", data);
      if(data.status == "ok"){
        success_alert(data.msg);
      }else{
         error_alert(data.msg);
      }
    },  function(status){
       hide_loader();
       console.log("failed with status", status);
       error_alert("failed with status", status);
    });

}

$('#feeds_table').DataTable({
  "bProcessing": true,
   "serverSide": true,
    "pageLength" : 10,
    "ajax": {
        url : baseURL+"getDevotionals",
        type : 'POST'
    },
    dom: 'frtip',
    "columnDefs": [
    { className: "td_width", "targets": [ 3,4 ] }
  ]
});


$("#article_type").change(function(){
    var type = $('#article_type option:selected').val();
    //alert(type);
    var html_content = document.getElementById('html_content');
    var link_content = document.getElementById('link_content');
    if(type=="article"){
       html_content.style.display = 'block';
       link_content.style.display = 'none';
    }else{
      link_content.style.display = 'block';
      html_content.style.display = 'none';
    }
});

function print_modal_show(e){
  e.preventDefault();
  $('#printCoupons').modal('show');
}

function delete_modal_show(e){
  e.preventDefault();
  $('#deleteCoupons').modal('show');
}
