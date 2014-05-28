<!-- general site style -->
<link href="/css/buttons.css" rel="stylesheet" type="text/css" />
<link href="/css/text.css" rel="stylesheet" type="text/css" />

<!-- feedback -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
 <script src="https://rawgit.com/ivoviz/feedback/master/feedback.js"></script>
 <link rel="stylesheet" href="https://raw.githubusercontent.com/ivoviz/feedback/master/feedback.min.css" />

 <script type="text/javascript">
     $.feedback({
         ajaxURL: 'http://test.url.com/feedback',
         html2canvasURL: 'https://raw.githubusercontent.com/ivoviz/feedback/master/html2canvas.min.js'
     });
 </script>

<button class="feedback-btn feedback-btn-gray">Send feedback</button>
