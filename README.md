# Nitish Jadia's Tech blog | https://jadia.dev

This site uses [Hugo](https://gohugo.io/) along with [Hyde-Hyde](https://themes.gohugo.io/hyde-hyde/) theme.

## Modifications

### Fix sidebar DP issue

[The issue](https://github.com/htr3n/hyde-hyde/issues/72#issuecomment-533411217) can be fixed by by removing `| replaceRE "^(/)+(.*)" "$2"` at line 18 in [layouts/partials/sidebar.html](layouts/partials/sidebar.html).

### Increase content width

Change value in `themes/hyde-hyde/assets/scss/hyde-hyde/_variables.scss`:

```css
 /* content */
/* $content-max-width: 38rem; // @ ~70 CPL */
$content-max-width: 60rem; // @ ~70 CPL
$content-margin-left: $sidebar-width + 5rem;
/* $content-margin-left: $sidebar-width + 2rem; */
$content-margin-right: 2rem;
```
