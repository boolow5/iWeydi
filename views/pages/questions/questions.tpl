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
        <span class='counter-item'>{{$val.LoveCount $.MyID}} | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">{{$val.HateCount $.MyID}} | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">{{$val.CommentCount}} | {{i18n $.Lang "commented_on_this"}}</span>
        <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-primary answer-btn' href='/question/{{$val.Id}}'>{{ i18n $.Lang "answer_this"}}</a>
      </div>

    {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
