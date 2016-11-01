<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{i18n $.Lang .Question.Text}}</h1>
    <div class="one-item-container">
      <p><strong>{{i18n $.Lang "description"}}:</strong></p>
      <p>{{.Question.Description}}</p>
      <hr/>


      <div class="a-item one-item-container">
        <form method="POST" action="/api/answer" id="new-answer-form">


            <!--<span class='input-group-addon form-control-arabic' id="basic-addon1">{{i18n .Lang "new_answer"}}</span>
            <input type="text" class="form-control form-control-arabic" name="text" placeholder='{{i18n .Lang "enter_answer_here"}}' id="answer-text-editor" aria-describedby="basic-addon1">
          -->
            <textarea class="textwrapper" name="text" placeholder='{{i18n .Lang "enter_answer_here"}}' rows="10" id="answer-text-editor"></textarea>

          <br>
          <button class="btn btn-primary" id="add-new-answer-btn">{{i18n .Lang "save"}}</button>

        </form>
      </div>

      <h1>{{i18n $.Lang "answers"}}</h1>

      {{range $val, $index := .Answers}}

      <div class="a-item one-item-container">
        <a href="#">
          <img class='a-item-author-img{{if eq .Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
        </a>
        <h3>
          <a href="#">
            Question for this answer?
          </a>
          <div class="a-item-header">
            <a href="#">
              <span class="a-item-author-name">Author Name</span>
              <span class="a-item-author-description">I'm the author of this answer</span>
            </a>
          </div>
        </h3>

        <p>The description of the answer will be layed out here the same as this text you're reading right now... <a href="#">read more!</a></p>
        <span>{{i18n $.Lang "time_before_hours" 12}} </span>
        <span class="counter-item">5 | {{i18n $.Lang "loved_this"}}</span>
        <span class="counter-item">2 | {{i18n $.Lang "hated_this"}}</span>
        <span class="counter-item">10 | {{i18n $.Lang "commented_on_this"}}</span>
      </div>



      {{end}}
    </div>

  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
