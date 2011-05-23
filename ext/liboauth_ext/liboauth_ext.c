#include <ruby.h>
#include "oauth.h"

static VALUE sym_request_url, sym_oauth_header;

static VALUE rb_liboauth_sign_url(VALUE klass, VALUE url, VALUE method, VALUE req_c_key, 
                                  VALUE req_s_key, VALUE token_key, VALUE token_secret) {
    if( url == Qnil || method == Qnil || req_c_key == Qnil || req_s_key == Qnil  ){
        return rb_hash_new();
    }

    int  argc;
    char **argv = NULL;
    argc = oauth_split_url_parameters(RSTRING_PTR(url), &argv);

    char *tkey = NULL;
    char *tsecret = NULL;
    if( token_key != Qnil ){
        tkey = RSTRING_PTR(token_key);
    }

    if( token_secret != Qnil ){
        tsecret = RSTRING_PTR(token_secret);
    }

    oauth_sign_array2_process(&argc, &argv,
            NULL, //< postargs (unused)
            OA_HMAC,
            RSTRING_PTR(method), //< HTTP method (defaults to "GET")
            RSTRING_PTR(req_c_key), RSTRING_PTR(req_s_key), tkey, tsecret);

    char *req_hdr = NULL;
    req_hdr = oauth_serialize_url_sep(argc, 1, argv, ", ", 6);
    char *req_url = NULL;
    req_url = oauth_serialize_url_sep(argc, 0, argv, "&", 1);

    VALUE oauth_hdr = rb_str_new(0,0);
    rb_str_cat2( oauth_hdr, "OAuth ");
    if( req_hdr && 0 < strlen(req_hdr) && req_hdr[0] == ',' && req_hdr[1] == ' ' ){
        rb_str_cat2( oauth_hdr, req_hdr + 2);
    }
    else{
        rb_str_cat2( oauth_hdr, req_hdr);
    }

    VALUE result_hash = rb_hash_new();
    rb_hash_aset(result_hash, sym_request_url, rb_str_new2( req_url ));
    rb_hash_aset(result_hash, sym_oauth_header, oauth_hdr);

    if( argv ){
        oauth_free_array(&argc, &argv);
    }
    if( req_hdr ){
        free(req_hdr);
    }
    if( req_url ){
        free(req_url);
    }

    return result_hash;
}

VALUE rb_liboauth_debug(VALUE klass, VALUE flg){
    if( flg == Qtrue ){
        oauth_debug(1);
    }
    else{
        oauth_debug(0);
    }
}

void Init_liboauth_ext(void){
    VALUE mLiboauth;
    mLiboauth = rb_define_module("Liboauth");
    rb_define_singleton_method(mLiboauth, "sign_url", rb_liboauth_sign_url, 6);
    rb_define_singleton_method(mLiboauth, "debug=", rb_liboauth_debug, 1);
    sym_request_url = ID2SYM(rb_intern("request_url"));
    sym_oauth_header = ID2SYM(rb_intern("oauth_header"));
}
