<div class="scrollspy">
    <ul id="main-menu" data-spy="affix" class="nav flex-column">
        <li class="nav-item">
            <a href="#doc-general-notes" class="nav-link">General notes</a>
        </li>
        {{ with $structures := .Structures }}
            <li class="nav-item">
                <a href="#doc-api-structures" class="nav-link">API structures</a>
                <ul>
                    {{ range $structures }}
                        <li>
                            <a href="#struct-{{ .Name }}">{{ .Name }}</a>
                        </li>
                    {{ end }}
                </ul>
            </li>
        {{ end }}
        <li class="nav-item">
            <a href="#doc-api-detail" class="nav-link">API detail</a>
        </li>
        {{ range .Requests }}
            <li class="nav-item">
                <a href="#request-{{ requestId . }}" class="nav-link">[{{ .Method }}] {{ .Name }}</a>
            </li>
        {{ end }}
        {{ range .Folders }}
            {{ $folder := . }}
            <li class="nav-item">
                <a href="#folder-{{ slugify $folder.Name }}" class="nav-link">{{ $folder.Name }}</a>
                <ul class="nav flex-column">
                    {{ range $folder.Requests }}
                        <li class="nav-item">
                            <a href="#request-{{ slugify $folder.Name }}-{{ requestId . }}"
                               class="nav-link">[{{ .Method }}]
                                {{ .Name }}</a>
                        </li>
                    {{ end }}
                </ul>
            </li>
        {{ end }}
    </ul>
</div>
