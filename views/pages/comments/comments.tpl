<ul class="comments-ul">
  {{range $index, $val := .Questions}}
    <li class="comment-li">
      <div class="one-comment">
        <p>
          {{$val.text}}
        </p>
        <p>
          <i class="fa fa-pencil fa-fw" aria-hidden="true"></i> {{$val.author_name}}
          <i class="fa fa-clock fa-fw" aria-hidden="true"></i> {{$val.created_at}}
        </p>
      </div>
    </li>
  {{end}}
</ul>
