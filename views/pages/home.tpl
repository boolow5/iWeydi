<div class="row">

  {{template "partials/left-sidebar.tpl"}}



  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="list-item-container q-list">
    {{range $index, $val := .Feeds}}
      <p> {{$val.Doer}} {{$val.ActivityType}}</p>
      <div class="one-item-container q-item">
        <strong></strong> {{i18n $.Lang "answered_this" $val.doer}}<br/>
        <h3><a href="/question/{{$val.q_id}}">{{$val.question_text}}</a></h3>
        <p>
          {{$val.text}}
        </p>
        <span>{{i18n $.Lang "time_written" }}:  {{ $val.created_at}} </span>

        <div class="btn-toolbar" role="group" aria-label="...">
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.q_id}}'>
            {{$val.love_count}}
            <span class='counter-text'>| {{i18n $.Lang "loved_this"}}</span>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.q_id}}'>
            {{$val.hate_count}}
            <span class="counter-text">| {{i18n $.Lang "hated_this"}}</span>
          </a>
          <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-default answer-btn' href='/question/{{$val.q_id}}'>
            {{$val.comment_count}}
            <span class="counter-text">| {{i18n $.Lang "commented_on_this"}}</span>
          </a>

          <a class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}btn btn-primary answer-btn' style='margin-right:1em;margin-left:1em;' href='/question/{{$val.q_id}}'>
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
