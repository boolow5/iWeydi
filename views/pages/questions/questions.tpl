<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="list-item-container q-list">
    {{range $index, $val := .Questions}}

      <div class="one-item-container q-item">
        <h3><a href="#">{{$val.Text}}</a></h3>
        <p>{{$val.Description}}</p>
        <span>{{$val.CreatedAt}} </span>
        <span class="counter-item">
          <span class="question-like-counter" id="{{$val.Id}}-question-like-counter">0</span>
          | {{i18n $.Lang "loved_this"}}
        </span>
        <span class="counter-item">
          <span class="question-dislike-counter" id="{{$val.Id}}-question-dislike-counter">0</span>
          | {{i18n $.Lang "hated_this"}}
        </span>
        <span class="counter-item">
          <span class="question-comment-counter" id="{{$val.Id}}-question-comment-counter">0</span>
          | {{i18n $.Lang "commented_on_this"}}
        </span>
      </div>
    {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
