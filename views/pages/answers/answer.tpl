<div class="row">

  {{template "partials/left-sidebar.tpl"}}

  <div class="col-sm-7">
    <h1>{{.Question.Text}}</h1>
    <div class="one-item-container">
      <p><strong>{{i18n $.Lang "description"}}:</strong></p>
      <p>{{.Question.Description}}</p>
    </div>


      <div class="a-item one-item-container">

          <div class="a-item-header">
            <a href="#" class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}{{if eq $.Lang "ar-SA"}}pull-left {{end}}'>
              <img class='a-item-author-img{{if eq $.Lang "ar-SA"}}-arabic{{end}}' src="/static/img/author.jpg">
            </a>
            <p>By: <a href="/user/{{.Answer.Author.Id}}">{{.Answer.Author.Profile.FullName }}</a><br/>
            <h3><a href="/answer/{{.Answer.Question.Id}}">&nbsp;</a></h3>
          </div>

          <p></p>
          <p>
            {{.Answer.Text | markdown}}
          </p>


          <span>{{i18n $.Lang "time_written" }}:  <a href="/answer/{{.Answer.Id}}" class="short-btn read-more-btn">{{dateformat .Answer.CreatedAt "02-01-06 15:04:05"}}</a> </span>


          <div class="btn-toolbar" role="group" aria-label="reaction area">
            <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-success short-btn'
              href='#' data-rtype="1" data-oid="{{.Answer.Id}}"
              data-btype="+" data-irt="2" data-opposite="{{.Answer.Id}}-dislike-counter"
              data-myid="{{.Answer.Id}}-like-counter">
              <span id="{{.Answer.Id}}-like-counter">
                {{.Answer.LoveCount}}
              </span>
              <i class="fa fa-thumbs-up fa-fw" aria-hidden="true"></i>
            </a>
            <a class='reaction-btn {{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-danger short-btn'
              href='#' data-rtype="0" data-oid="{{.Answer.Id}}"
              data-btype="-" data-irt="2"
              data-myid="{{.Answer.Id}}-dislike-counter"
              data-opposite="{{.Answer.Id}}-like-counter">
              <span id="{{.Answer.Id}}-dislike-counter">
                {{.Answer.HateCount}}
              </span>
              <i class="fa fa-thumbs-down fa-fw" aria-hidden="true"></i>
            </a>
            <a class='{{if eq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn comment-counter-btn' data-parentType="2" data-parentId="{{.Answer.Id}}"
              data-targetForm="{{.Answer.Id}}-comments-form" data-targetList="{{.Answer.Id}}-comments-list" href='#'>
              <span>
                {{.Answer.CommentCount}}
              </span>
              <i class="fa fa-comments fa-fw" aria-hidden="true"></i>
            </a>

            <a class='{{if neq $.Lang "ar-SA"}}pull-right {{end}}btn btn-info short-btn' style='margin-right:1em;margin-left:1em;' href='/question/{{.Answer.Question.Id}}'>
              {{ i18n $.Lang "answer_this"}} <i class="fa fa-reply fa-fw" aria-hidden="true"></i>
            </a>
          </div>
          <div class="comment-wrapper">
            <div id="{{.Answer.Id}}-comments-form" class="comment-form hidden" data-itemType="1" data-parentId="{{.Answer.Id}}">

            </div>
            <div id="{{.Answer.Id}}-comments-list" class="comments-list">

            </div>
          </div>



      </div>


  </div>
  <br>
  {{template "partials/right-sidebar.tpl"}}
</div>
