/**************************************************************************
 * 
 * Copyright 2007 VMware, Inc.
 * All Rights Reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sub license, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice (including the
 * next paragraph) shall be included in all copies or substantial portions
 * of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
 * IN NO EVENT SHALL VMWARE AND/OR ITS SUPPLIERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 **************************************************************************/


#ifndef ST_CB_FBO_H
#define ST_CB_FBO_H

#include "main/compiler.h"
#include "main/glheader.h"
#include "main/mtypes.h"

#include "pipe/p_compiler.h"
#include "pipe/p_format.h"

struct dd_function_table;
struct pipe_context;

/**
 * Derived renderbuffer class.  Just need to add a pointer to the
 * pipe surface.
 */
struct st_renderbuffer
{
   struct gl_renderbuffer Base;
   struct pipe_resource *texture;
   struct pipe_surface *surface; /* temporary view into texture */
   GLboolean defined;        /**< defined contents? */

   struct pipe_transfer *transfer; /**< only used when mapping the resource */

   /**
    * Used only when hardware accumulation buffers are not supported.
    */
   boolean software;
   void *data;

   bool use_readpix_cache;

   /* Inputs from Driver.RenderTexture, don't use directly. */
   boolean is_rtt; /**< whether Driver.RenderTexture was called */
   unsigned rtt_face, rtt_slice;
   boolean rtt_layered; /**< whether glFramebufferTexture was called */
};


static inline struct st_renderbuffer *
st_renderbuffer(struct gl_renderbuffer *rb)
{
   return (struct st_renderbuffer *) rb;
}


extern struct gl_renderbuffer *
st_new_renderbuffer_fb(enum pipe_format format, int samples, boolean sw);

extern void
st_update_renderbuffer_surface(struct st_context *st,
                               struct st_renderbuffer *strb);

extern void
st_init_fbo_functions(struct dd_function_table *functions);

#endif /* ST_CB_FBO_H */
