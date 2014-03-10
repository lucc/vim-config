" Vim syntax file
" Language:
" Maintainer:
" Last Change:
" Version:
" URL:
"
" The manpage for sshd(8) describes the format of the known_hosts file:
"
"  Each line in these files contains the following fields: markers (optional),
"  hostnames, bits, exponent, modulus, comment.  The fields are separated by
"  spaces.
"
"  The marker is optional, but if it is present then it must be one of
"  ``@cert-authority'', to indicate that the line contains a certification
"  authority (CA) key, or ``@revoked'', to indicate that the key contained on
"  the line is revoked and must not ever be accepted.  Only one marker should
"  be used on a key line.
"
"  Hostnames is a comma-separated list of patterns (`*' and `?' act as
"  wildcards); each pattern in turn is matched against the canonical host name
"  (when authen- ticating a client) or against the user-supplied name (when
"  authenticating a server).  A pattern may also be preceded by `!' to
"  indicate negation: if the host name matches a negated pattern, it is not
"  accepted (by that line) even if it matched another pattern on the line.  A
"  hostname or address may optionally be enclosed within `[' and `]' brackets
"  then followed by `:' and a non-standard port number.
"
"  Alternately, hostnames may be stored in a hashed form which hides host
"  names and addresses should the file's contents be disclosed.  Hashed
"  hostnames start with a `|' character.  Only one hashed hostname may appear
"  on a single line and none of the above negation or wildcard operators may
"  be applied.

" TODO: version checks


