<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="list-item-container q-list">
    {{range $index, $val := .Questions}}

      <div class="one-item-container q-item">

        <h3><a href="/question/{{$val.Id}}">{{$val.Text}}</a></h3>
        <p>{{$val.Description}}</p>
        <span>{{i18n $.Lang "time_written" }}:  {{dateformat $val.CreatedAt "02-01-06 15:04:05"}} </span>

        <div class="btn-toolbar" role="group" aria-label="...">
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
            {{$val.LoveCount}}
            <span class='counter-text'>| {{i18n $.Lang "loved_this"}}</span>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
            {{$val.HateCount}}
            <span class="counter-text">| {{i18n $.Lang "hated_this"}}</span>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.Id}}'>
            {{$val.CommentCount}}
            <span class="counter-text">| {{i18n $.Lang "commented_on_this"}}</span>
          </a>

          <a class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}btn btn-primary answer-btn' style='margin-right:1em;margin-left:1em;' href='/question/{{$val.Id}}'>
            {{ i18n $.Lang "answer_this"}}
          </a>
        </div>


      </div>

    {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
