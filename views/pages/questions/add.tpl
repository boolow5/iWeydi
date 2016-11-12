<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Title}}</h1>
    <div class="one-item-container q-list">
      <form id="question-form" class="form" method="post" action="/api/question">
        {{ .xsrfdata }}
        <div class="input-group">
          <span class='input-group-addon{{if eq .Lang "ar-SA"}} horizontal-mirror{{end}} form-control-arabic' id="basic-addon1"><i class="fa fa-question-circle fa-fw" aria-hidden="true"></i> </span>
          <input type="text" class="form-control form-control-arabic" required name="text" placeholder='{{i18n .Lang "enter_question_here"}}' id="question-text-editor" aria-describedby="basic-addon1">
        </div>
        <textarea class="form-control form-control-arabic" rows="7" name="description" placeholder='{{i18n .Lang "enter_description_here"}}' id="question-text-editor" aria-describedby="basic-addon1"></textarea>
        <br>
        <button class="btn btn-primary" id="add-new-question-btn"> <i class="fa fa-send fa-fw" aria-hidden="true"></i> {{i18n .Lang "send"}}</button>
      </form>
    </div>
  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
