<form id="new-comment-form-{{.ParentId}}-{{.ParentType}}"  class="comment-form" method="post" action="/api/comment/{{.ParentType}}/{{.ParentId}}" onsubmit="return false">
  {{ .xsrfdata }}
  <textarea class="textwrapper" name="text" placeholder='{{i18n .Lang "enter_comment_here"}}' rows="3" id="comment-text-editor"></textarea>
  <button class="btn btn-primary" id="new-comment-btn-{{.ParentId}}-{{.ParentType}}" onclick="submitComment('new-comment-form-{{.ParentId}}-{{.ParentType}}')">{{i18n .Lang "save"}}</button>
</form>
