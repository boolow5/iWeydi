<div id="top-row-header">
  <div class="container">
    <ul class="nav nav-pills" role="tablist">

      <li class='presentation {{if eq .Lang "ar-SA"}}pull-right{{end}}'>
        <ul class='nav nav-pills{{if eq .Lang "ar-SA" }} arabic-menu-list{{end}}' role="tablist">

        {{if neq .Lang "ar-SA"}}
          <li role='presentation'>
            <a class="head-brand-name" href="/"><img src="/static/icons/favicon-32x32.png" height="20px"> &nbsp; iWeydi</a>
          </li>
          <li role='presentation' class='{{if eq .Title "home"}} active{{end}}'><a href="/"> <i class="fa fa-home fa-fw" aria-hidden="true"></i> {{i18n $.Lang "home"}} <span class="badge">42</span></a></li>
          {{if .LoggedIn }}
          <li role='presentation' class='{{if eq .Title "messages"}} active{{end}}'><a href="/messages"> <i class="fa fa-envelope fa-fw" aria-hidden="true"></i> {{i18n $.Lang "messages"}} <span class="badge">3</span></a></li>
          <li role='presentation' class='{{if eq .Title "notifications"}} active{{end}}'><a href="/notifactions"> <i class="fa fa-bell fa-fw" aria-hidden="true"></i> {{i18n $.Lang "notifications"}} <span class="badge">39</span></a></li>

          <li role="presentation" class='{{if eq .Title "questions"}} active{{end}}'>
            <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
               <i class="fa fa-question-circle fa-fw" aria-hidden="true"></i> {{i18n $.Lang "questions"}} <span class="badge">5</span>  <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <li role="presentation" class='{{if eq .Title "browse_questions"}} active{{end}}'><a href="/questions">{{i18n $.Lang "browse_questions"}}</a></li>
              {{if .LoggedIn }}
              <li role="presentation" class='{{if eq .Title "followed_questions"}} active{{end}}'><a href="/followed/questions">{{i18n $.Lang "followed_questions"}}  <span class="badge">5</span></a></li>
              <li role="presentation" class='questions_by_friend'><a href="/followed/users/questions">{{i18n $.Lang "questions_by_friend"}}</a></li>
              <li role="presentation" class='{{if eq .Title "add_question"}} active{{end}}'><a href="/question">{{i18n $.Lang "add_question"}}</a></li>
              {{end}}
            </ul>
          </li>



          {{end}}
        {{end}}


        {{if eq .Lang "ar-SA"}}

        <li role="presentation" class='{{if eq .Title "questions"}} active{{end}}'>
          <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
            <i class="fa fa-question-circle fa-fw" aria-hidden="true"></i> {{i18n $.Lang "questions"}} <span class="badge">5</span>  <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li role="presentation" class='{{if eq .Title "browse_questions"}} active{{end}}'><a href="/questions">{{i18n $.Lang "browse_questions"}}</a></li>
            {{if .LoggedIn }}
            <li role="presentation" class='{{if eq .Title "followed_questions"}} active{{end}}'><a href="/followed/questions">{{i18n $.Lang "followed_questions"}}  <span class="badge">5</span></a></li>
            <li role="presentation" class='{{if eq .Title "questions_by_friend"}} active{{end}}'><a href="/followed/users/questions">{{i18n $.Lang "questions_by_friend"}}</a></li>
            <li role="presentation" class='{{if eq .Title "add_question"}} active{{end}}'><a href="/question">{{i18n $.Lang "add_question"}}</a></li>
            {{end}}
          </ul>
        </li>


          {{if .LoggedIn }}
          <li role='presentation' class='{{if eq .Title "notifications"}} active{{end}}'><a href="/notifactions"> <i class="fa fa-bell fa-fw" aria-hidden="true"></i> {{i18n $.Lang "notifications"}} <span class="badge">39</span></a></li>
          <li role='presentation' class='{{if eq .Title "messages"}} active{{end}}'><a href="/messages"> <i class="fa fa-envelope fa-fw" aria-hidden="true"></i> {{i18n $.Lang "messages"}} <span class="badge">3</span></a></li>
          {{end}}
          <li role='presentation' class='{{if eq .Title "home"}} active{{end}}'><a href="/"> <i class="fa fa-home fa-fw" aria-hidden="true"></i> {{i18n $.Lang "home"}} <span class="badge">42</span></a></li>

          <li role='presentation'>
            <a class="head-brand-name" href="/"><img src="/static/icons/favicon-32x32.png" height="20px"> &nbsp; iWeydi</a>
          </li>
        {{end}}
        </ul>
      </li>

      <li class='presentation {{if neq .Lang "ar-SA"}}pull-right{{end}}'>
        <ul class="nav nav-pills" role="tablist">
          <li role="presentation" class='dropdown{{if eq .Title "profile"}} active{{end}}'>
            <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
              <i class="fa fa-user fa-fw" aria-hidden="true"></i> {{if .LoggedIn }}{{ .FullName }}{{end}}{{if .NotLoggedIn}}{{i18n $.Lang "account"}}{{end}} <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              {{if .NotLoggedIn }}
              <li role="presentation"><a href="/user/login">{{i18n $.Lang "login"}}</a></li>
              <li role="presentation"><a href="/user/register">{{i18n $.Lang "register"}}</a></li>
              {{end}}
              {{if .LoggedIn }}
              <li role="presentation"><a href="/user/profile">{{i18n $.Lang "profile"}}</a></li>
              <li role="presentation"><a href="/user/logout">{{i18n $.Lang "logout"}}</a></li>
              {{end}}
            </ul>
          </li>



          <li role="presentation" class='dropdown{{if eq .Title "profile"}} active{{end}}'>
            <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
              <i class="fa fa-language fa-fw" aria-hidden="true"></i> {{i18n $.Lang "languages"}} <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              {{range .RestLangs}}
                  <li><a href="javascript::" data-lang="{{.Lang}}" class="lang-changed"> {{i18n $.Lang .Name}}</a></li>
              {{end}}
            </ul>
          </li>

        </ul>

      </li>


    </ul>
  </div>

</div>
