<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ .Name }}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@9.16.2/build/styles/monokai-sublime.min.css">
    <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@9.16.2/build/highlight.min.js"></script>
    <script>
        hljs.configure({
            tabReplace: '    ',
        });
        hljs.initHighlightingOnLoad();

        $("ul.nav-tabs a").click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        });

    </script>
    <style>{{ template "custom.css" }}</style>
</head>
<body data-spy="scroll" data-target=".scrollspy">
<div id="sidebar-wrapper">
    {{ template "menu.tpl" . }}
</div>
<div id="page-content-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <h1>{{ .Name }}</h1>

                <h2 id="doc-general-notes">
                    General notes
                    <a href="#doc-general-notes"><i class="fa fa-link"></i></a>
                </h2>

                {{ markdown .Description }}

                {{ with $structures := .Structures }}
                    <h2 id="doc-api-structures">
                        API structures
                        <a href="#doc-api-structures"><i class="fa fa-link"></i></a>
                    </h2>

                    {{ range $structures }}

                        <h3 id="struct-{{ .Name }}">
                            {{ .Name }}
                            <a href="#struct-{{ .Name }}"><i class="fa fa-link"></i></a>
                        </h3>

                        <p>{{ .Description }}</p>

                        <table class="table table-bordered">
                            {{ range .Fields }}
                                <tr>
                                    <th>{{ .Name }}</th>
                                    <td>{{ .Type }}</td>
                                    <td>{{ .Description }}</td>
                                </tr>
                            {{ end }}
                        </table>

                    {{ end }}

                {{ end }}

                <h2 id="doc-api-detail">
                    API detail
                    <a href="#doc-api-detail"><i class="fa fa-link"></i></a>
                </h2>

                {{ range .Folders }}
                    {{ $folder := . }}
                    <div class="endpoints-group">
                        <h3 id="folder-{{ slugify $folder.Name }}">
                            {{ .Name }}
                            <a href="#folder-{{ slugify $folder.Name }}"><i class="fa fa-link"></i></a>
                        </h3>

                        <div>{{ markdown $folder.Description }}</div>

                        {{ range $folder.Requests }}
                            {{ $req := . }}
                            {{ $id := requestId $req }}
                            <div class="request">

                                <h4 id="request-{{ slugify $folder.Name }}-{{ $id }}">
                                    [{{ $req.Method }}]
                                    {{ $req.Name }}
                                    <a href="#request-{{ slugify $folder.Name }}-{{ $id }}"><i
                                                class="fa fa-link"></i></a>
                                </h4>
                                <pre><code>{{ $req.URL }}</code></pre>
                                <div>{{ markdown $req.Description }}</div>

                                {{ with $req.Responses }}
                                    <div>
                                        <ul class="nav nav-pills" role="tablist">
                                            {{ range $index, $res := . }}
                                                <li role="presentation"
                                                    class="nav-item">
                                                    <a href="#request-{{ slugify $folder.Name }}-{{ $id }}-responses-{{ $index }}-{{ $res.ID }}"
                                                       class="nav-link {{ if eq $index 0 }} active{{ end }}"
                                                       data-toggle="pill">
                                                        {{ if eq (len $req.Responses) 1 }}
                                                            Response
                                                        {{ else}}
                                                            {{ $res.Name }}
                                                        {{ end }}
                                                    </a>
                                                </li>
                                            {{ end }}
                                        </ul>
                                        <div class="tab-content">
                                            {{ range $index, $res := . }}
                                                <div class="tab-pane{{ if eq $index 0 }} active{{ end }}"
                                                     id="request-{{ slugify $folder.Name }}-{{ $id }}-responses-{{ $index }}-{{ $res.ID }}">
                                                    <div>
                                                        <ul class="nav nav-tabs" role="tablist">
                                                            <li role="presentation" class="nav-item"><a
                                                                        href="#request-{{ slugify $folder.Name }}-{{ $id }}-{{ $index }}-{{ $res.ID }}-example-curl"
                                                                        class="nav-link active"
                                                                        data-toggle="tab">Curl</a></li>
                                                            <li role="presentation" class="nav-item"><a
                                                                        href="#request-{{ slugify $folder.Name }}-{{ $id }}-{{ $index }}-{{ $res.ID }}-example-http"
                                                                        class="nav-link"
                                                                        data-toggle="tab">HTTP</a></li>
                                                        </ul>
                                                        <div class="tab-content">
                                                            <div class="tab-pane active"
                                                                 id="request-{{ slugify $folder.Name }}-{{ $id }}-{{ $index }}-{{ $res.ID }}-example-curl">
                                                                <pre><code class="hljs curl">{{ curlSnippet $res.OriginalRequest }}</code></pre>
                                                            </div>
                                                            <div class="tab-pane"
                                                                 id="request-{{ slugify $folder.Name }}-{{ $id }}-{{ $index }}-{{ $res.ID }}-example-http">
                                                                <pre><code class="hljs http">{{ httpSnippet $res.OriginalRequest }}</code></pre>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <table class="table table-bordered table-sm">
                                                        <tr>
                                                            <th style="width: 20%;">Status</th>
                                                            <td>{{ $res.StatusCode }} {{ $res.Status }}</td>
                                                        </tr>
                                                        {{ range $res.Headers }}
                                                            <tr>
                                                                <th style="width: 20%;">{{ .Name }}</th>
                                                                <td>{{ .Value }}</td>
                                                            </tr>
                                                        {{ end }}
                                                        {{ if hasContent $res.Body }}
                                                            {{ with $example := indentJSON $res.Body }}
                                                                <tr>
                                                                    <td class="response-text-sample" colspan="2">
                                                                        <pre class="pre-scrollable"><code>{{ $example }}</code></pre>
                                                                    </td>
                                                                </tr>
                                                            {{ end }}
                                                        {{ end }}
                                                    </table>
                                                </div>
                                            {{ end }}
                                        </div>
                                    </div>
                                {{ end }}

                                <hr>
                            </div>
                        {{ end }}

                    </div>
                {{ end }}
            </div>
        </div>
    </div>
</div>
</body>
</html>
