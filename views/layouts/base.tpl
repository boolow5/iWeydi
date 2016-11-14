<!DOCTYPE html>
<html lang="en"{{if eq .Lang "ar-SA"}} DIR="RTL"{{end}}>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content='{{i18n .Lang "app_intro"}}'>
    <meta name="author" content="Mahdi Bolow">

    <meta name="twitter:card" content="summary" />
    <meta name="twitter:site" content="@iweydi" />
    <meta name="twitter:creator" content="@mahdibolow" />
    <meta property="og:url" content="http://localhost:8080" />
    <meta property="og:title" content='{{i18n .Lang "about"}} - {{i18n .Lang "app_short_description"}}' />
    <meta property="og:description" content='{{i18n .Lang "app_description"}}' />
    <meta property="og:image" content="/static/img/iweydi-bg-social.png" />
    <!--<meta name="_xsrf" content="{{.xsrf_token}}" />-->

    <title>{{i18n .Lang .Title}} - {{i18n .Lang "app_short_description"}}</title>

    <link rel="apple-touch-icon" sizes="57x57" href="/static/icons/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/static/icons/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/static/icons/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/static/icons/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/static/icons/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/static/icons/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/static/icons/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/static/icons/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/static/icons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192"  href="/static/icons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/static/icons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="/static/icons/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/static/icons/favicon-16x16.png">
    <link rel="manifest" href="/static/icons/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="/static/icons/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">

    <!-- Bootstrap -->
    <link href="/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/font-awesome-4.4.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="/static/css/main.css" rel="stylesheet">

    <script src="/static/js/jquery-2.1.1.js"></script>


    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    {{.NavPills}}
    <div class="container">

      <div class="row">
        <div class="alert alert-danger hidden" role="alert" id="error"></div>
        <div class="alert alert-success hidden" role="alert" id="success"></div>
      </div>
      <div class="row">
        {{.SearchBar}}
      </div>
      {{.LayoutContent}}
    </div>

    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="/static/js/bootstrap.min.js"></script>
    <script src="/static/js/jquery_cookie.js"></script>
    <script src="/static/js/require.js"></script>
    <script src="/static/js/main.js"></script>
    <script>
      $("#topics_you_follow").html('{{i18n .Lang "topics_you_follow"}}');
    </script>

  </body>
</html>
