/* Copyright distributed.net 1997 - All Rights Reserved
 * For use in distributed.net projects only.
 * Any other distribution or use of this source violates copyright.
 *
 * $Log: buffbase.cpp,v $
 * Revision 1.1  1999/04/01 01:49:55  cyp
 * Created BufferFetchFile()/BufferFlushFile() to fetch/flush from/to remote/
 * alternate buffers.
 *
 *
*/

#if (!defined(lint) && defined(__showids__))
const char *buffbase_cpp(void) {
return "@(#)$Id: buffbase.cpp,v 1.1 1999/04/01 01:49:55 cyp Exp $"; }
#endif

#include "cputypes.h"
#include "client.h"   //client class
#include "baseincs.h" //basic #includes
#include "network.h"  //ntohl(), htonl()
#include "util.h"     //IsFilenameValid(), DoesFileExist()
#include "clievent.h" //event stuff
#include "clicdata.h" //GetContestNameFromID() 
#include "logstuff.h" //Log()/LogScreen()/LogScreenPercent()/LogFlush()
#include "triggers.h" //[Check|Raise][Pause|Exit]RequestTrigger()
#include "pathwork.h" //GetFullPathForFilename() or dummy if DONT_USE_PATHWORK
#include "problem.h"  //Resultcode enum
#include "buffwork.h" //our defines
#define __iter2norm( iterlo, iterhi ) ((iterlo >> 28) + (iterhi << 4))


/* --------------------------------------------------------------------- */

static int BufferPutMemRecord( struct membuffstruct *membuff,
    const WorkRecord* data, unsigned long *countP ) /* returns <0 on ioerr */
{
  int retcode = -1;
  WorkRecord *dest;

  if (membuff->count == 0)
  {
    unsigned int i;
    for (i = 0; i < MAXBLOCKSPERBUFFER; i++)
      membuff->buff[i]=NULL;
  }

  if (membuff->count < MAXBLOCKSPERBUFFER)
  {
    dest = (WorkRecord *)malloc(sizeof(WorkRecord));
    if (dest != NULL)
    {
      memcpy( (void *)dest, (void *)data, sizeof( WorkRecord ));
      membuff->buff[membuff->count] = dest;
      membuff->count++;
      if (countP)
        *countP = membuff->count;
      retcode = 0;
    }
  }
  return retcode;
}    


/* --------------------------------------------------------------------- */


static int BufferGetMemRecord( struct membuffstruct *membuff,
                           const WorkRecord* data, unsigned long *countP ) 
{
  /*  <0 on ioerr, >0 if norecs */
  int retcode = 1;
  WorkRecord *src;

  if (membuff->count > 0)
  {
    retcode = -1;
    membuff->count--;
    src = membuff->buff[membuff->count];
    membuff->buff[membuff->count] = NULL;
    if (src != NULL)
    {
      retcode = 0;
      memcpy( (void *)data, (void *)src, sizeof( WorkRecord ));
      free( (void *)src );
      if (countP)
        *countP = membuff->count;
    }
  }
  return retcode;
}    


/* --------------------------------------------------------------------- */


static int BufferCountMemRecords( struct membuffstruct *membuff,
   unsigned int contest, unsigned long *packetcountP, unsigned long *normcountP )
{
  unsigned long rec, reccount = 0, packetcount = 0, normcount = 0;
  int retcode = -1;
  
  if (membuff != NULL)
  {
    retcode = 0;
    normcount = 0;
    reccount = membuff->count;
    if (normcountP)
    {
      packetcount = 0;
      for (rec = 0; rec < reccount; rec++)
      {
        if ( membuff->buff[rec] != NULL )
        {
          WorkRecord workrec;
          memcpy((void *)&workrec, (void *)(membuff->buff[rec]),sizeof(WorkRecord));
          if (((unsigned int)workrec.contest) == contest)
          {
            packetcount++;
            switch (workrec.contest) 
            {
              case 0: // RC5
              case 1: // DES
                normcount += (unsigned int)
                   __iter2norm( workrec.work.crypto.iterations.lo, 
                                workrec.work.crypto.iterations.hi );
                break;
              case 2: // OGR
                normcount++;
                break;
            }
          }
        }
      }
      reccount = packetcount;
    }
  }
  if (retcode == 0)
    {
    if (normcountP)
      *normcountP = normcount;
    if (packetcountP)
      *packetcountP = reccount;
    }
  return retcode;
}

/* ===================================================================== */
/*                      END OF MEMBUFF PRIMITIVES                        */
/* ===================================================================== */

int GetFileLengthFromStream( FILE *file, u32 *length )
{
  #if (CLIENT_OS == OS_WIN32) || (CLIENT_OS == OS_WIN32S)
    u32 result = (u32) GetFileSize((HANDLE)_get_osfhandle(fileno(file)),NULL);
    if (result == 0xFFFFFFFFL) return -1;
    *length = result;
  #elif (CLIENT_OS == OS_DOS) || (CLIENT_OS == OS_WIN16) 
    u32 result = filelength( fileno(file) );    
    if (result == 0xFFFFFFFFL) return -1;
    *length = result;
  #elif (CLIENT_OS == OS_MACOS)
    u32 result = my_getopenfilelength(fileno(file));
    *length = result;
  #else
    struct stat statbuf;
    #if (CLIENT_OS == OS_NETWARE)
    unsigned long inode;
    int vno;
    if (FEMapHandleToVolumeAndDirectory( fileno(file), &vno, &inode )!=0)
      { vno = 0; inode = 0; }
    if ( vno == 0 && inode == 0 )
    {                                       /* file on DOS partition */
      u32 result = filelength( fileno(file) );  // ugh! uses seek
      if (result == 0xFFFFFFFFL) return -1;
      *length = result;
      return 0;
    }
    #endif
    if ( fstat( fileno( file ), &statbuf ) != 0) return -1;
    *length = (u32)statbuf.st_size;
  #endif
  return 0;
}  

/* --------------------------------------------------------------------- */

//Do it the way I originally intended...
#if ((CLIENT_OS == OS_BEOS) || (CLIENT_OS == OS_NEXTSTEP))
  #define BUFFEROPEN( fn )  fopen( fn, "r+b" )
  #define BUFFERCREATE( fn )   fopen( fn, "wb" )
#elif (CLIENT_OS == OS_MACOS)
  #define BUFFEROPEN( fn )  fopen( fn, "r+b" )
  #define BUFFERCREATE( fn )   fopen( fn, "wb" )
  #define ftruncate(h,sz) //nothing. ftruncate not supported.
#elif (CLIENT_OS == OS_AMIGAOS)
  #define BUFFEROPEN( fn )  fopen( fn, "r+" )
  #define BUFFERCREATE( fn )   fopen( fn, "w" )
  #define ftruncate(h,sz) //nothing. ftruncate not supported.
#elif (CLIENT_OS == OS_SUNOS) && (CLIENT_CPU == CPU_68K)
  #define BUFFEROPEN( fn )  fopen( fn, "r+" )
  #define BUFFERCREATE( fn )   fopen( fn, "w" )
  extern "C" int ftruncate(int, off_t); // Keep g++ happy.
#elif (CLIENT_OS == OS_VMS)
  #define BUFFEROPEN( fn )  fopen( fn, "r+" )
  #define BUFFERCREATE( fn )   fopen( fn, "w" )
  #define ftruncate(h,sz) //nothing. ftruncate not supported.
#elif (CLIENT_OS == OS_RISCOS)
  #define BUFFEROPEN( fn )  fopen( fn, "r+b" )
  #define BUFFERCREATE( fn )   fopen( fn, "wb" )
#elif ((CLIENT_OS == OS_DOS) || (CLIENT_OS == OS_WIN32) || \
       (CLIENT_OS == OS_NETWARE) || (CLIENT_OS == OS_OS2) || \
       (CLIENT_OS == OS_WIN16) || (CLIENT_OS == OS_WIN32S))
  #define ftruncate(h,sz) chsize(h,sz)
  #define BUFFERCREATE( fn ) fopen( fn, "wb" )
  static FILE *BUFFEROPEN(const char *fn) 
  { 
    #if (CLIENT_OS == OS_NETWARE) 
    DIR *dir = opendir( fn );
    if ( dir != NULL && ( readdir( dir ) != NULL ) )
    {
      dir->d_cdatetime=(dir->d_cdatetime >> 16 | dir->d_cdatetime << 16);
      dir->d_adatetime=(dir->d_adatetime >> 16 | dir->d_adatetime << 16);
      long mdatetime  =(dir->d_date | dir->d_time << 16);
      dir->d_bdatetime=(dir->d_bdatetime >> 16 | dir->d_bdatetime << 16);
 
      SetFileInfo( (char *)(fn), 0x06, (dir->d_attr|_A_SHARE|_A_IMMPURG),
                   (char *)(&dir->d_cdatetime), (char *)(&dir->d_adatetime), 
                   (char *)(&mdatetime), (char *)(&dir->d_bdatetime), 
                   dir->d_uid  ); 
      closedir( dir );
      //technically could now use normal fopen().
    }
    #endif
    int handle = sopen(fn, O_RDWR|O_BINARY, SH_DENYNO); 
    return ((handle == -1) ? (NULL) : (fdopen(handle, "r+b"))); 
  }
#else
  #define BUFFEROPEN( fn )  fopen( fn, "r+" )
  #define BUFFERCREATE( fn )   fopen( fn, "w" )
#endif

/* --------------------------------------------------------------------- */

#ifndef SUPPRESS_FILE_BUFFER_PRIMITIVES

int BufferZapFileRecords( const char *filename )
{
  /* truncate, don't erase buffers (especially checkpoints). This reduces */
  /* disk fragmentation (on some systems) and is better on systems with a */
  /* "trash can" that saves deleted files. */

  if (!IsFilenameValid( filename ))
    return 0;
  filename = GetFullPathForFilename( filename );
  if (access( filename, 0 )!=0) //file doesn't exist, which is ok
    return 0;
  file = BUFFERCREATE( filename ); //truncate the file to zero length
  if (!file)
  {
    remove(filename); //write failed, so delete it
    return -1;
  }
  fclose(file);
  return(0);
}  


/* --------------------------------------------------------------------- */

static FILE *BufferOpenFile( const char *filename, unsigned long *countP )
{
  FILE *file = NULL;
  int failed = 0;
  u32 filelen;

  filename = GetFullPathForFilename( filename );

  if (access( filename, 0 ) != 0) // file doesn't exist, so create it
  {
    if ((file = BUFFERCREATE( filename ))==NULL)
      failed = 1;
    else // file created. may be an exclusive open, so close and reopen
      fclose( file );
    }
  }
  if (failed == 0)
  {
    if (access( filename, 0 )!=0) // file still doesn't exist
    {
      Log("Error opening buffer file... Access was denied.\n" );
      return NULL;
    }
    if ((file = BUFFEROPEN( filename ))==NULL)
      failed = 1;
  }
  if (failed != 0)
  {
    Log("Open failed. Check your file privileges (or your disk).\n" );
    return NULL;
  }

  if (fflush( file ) != 0 || GetFileLengthFromStream( file, &filelen ) != 0)
  {
    Log("Open failed. Unable to obtain directory information.\n");
    fclose( file );
    return NULL;
  }
  if ((filelen % sizeof(WorkRecord)) != 0)
  {
    Log("Open failed. Buffer file record count is inconsistent.\n");
    fclose( file );
    return NULL;
  }
  if (countP)
    *countP = (filelen / sizeof(WorkRecord));
  return file;
}

/* --------------------------------------------------------------------- */

static int BufferCloseFile( FILE *file )
{
  fclose(file);
  return 0;
}  

/* --------------------------------------------------------------------- */

static void  __switchborder( WorkRecord *dest, const WorkRecord *source )
{ 
  if (((cost WorkRecord *)dest) != source )
    memcpy( (void *)dest, (void *)source, sizeof(WorkRecord));
  /* we don't do PDP byte order, so this is ok */
  switch (dest->workrec.contest) 
  {
    case 0: // RC5
    case 1: // DES
    {
      u32 *w = (u32 *)(&(dest->workrec.work.crypto));
      for (i=0; i<(sizeof(dest->workrec.work.crypto)/sizeof(u32)); i++)
        w[i] = ntohl(w[i]);
      break;
    }
    case 2: // OGR
    {
      dest->workrec.work.ogr.stub.marks  = ntohs(dest->workrec.work.ogr.stub.marks);
      dest->workrec.work.ogr.stub.length = ntohs(dest->workrec.work.ogr.stub.length);
      for (i = 0; i < STUB_MAX; i++) 
        dest->workrec.work.ogr.stub.stub[i] = ntohs(dest->workrec.work.ogr.stub.stub[i]);
      break;
    }
  }
  return;
}  

/* --------------------------------------------------------------------- */

int UnlockBuffer( const char *filename )
{
  FILE *file = BufferOpen( filename, NULL );
  if (file)
  {
    BufferClose( file );
    LogScreen("%s has been unlocked.\n",filename);
    return 0;
  }
  return -1; /* error message will already have been printed */
}  

/* --------------------------------------------------------------------- */

int BufferPutFileRecord( const char *filename, const WorkRecord * data, 
                         unsigned long *countP ) 
{
  unsigned long reccount;
  FILE *file = BufferOpen( filename, &reccount );
  int failed = -1;
  if ( file )
  {
    unsigned long recno = 0;
    WorkRecord blank, scratch;
    memset( (void *)&blank, 0, sizeof(blank) );
    failed = 0;
    if ( fseek( file, 0, SEEK_SET ) != 0)
      failed = -1;
    while (!failed && recno < reccount)
    {
      if ( fread( (void *)&scratch, sizeof(WorkRecord), 1, file ) != 1)
        failed = -1;
      else if ( 0 == memcmp( (void *)&scratch, (void *)&blank, sizeof(WorkRecord)))
        break; /* blank record, write here */
      recno++
    }
    if (!failed)
    {
      failed = -1;
      __switchborder( &scratch, data );
      if ( fseek( file, (recno * sizeof(WorkRecord)), SEEK_SET ) == 0 &&
                fwrite( (void *)scratch, sizeof(WorkRecord), 1, file ) == 1 )
        failed = 0;
    }
    BufferCloseFile( file );
  }
  if (!failed && countP)
    BufferCountFileRecords( filename, data->contest, countP, NULL );
  return failed;
}  
  
/* --------------------------------------------------------------------- */

int Client::BufferUpdate( int updatereq_flags, int interactive )
{ 
  char loaderflags_map[CONTEST_COUNT];
  int failed, dofetch, doflush, didfetch, didflush, dontfetch, dontflush;
  unsigned int i, contest_i;
  const char *ffmsg="--fetch and --flush services are not available.\n";

  if (remote_update_dir[0] == 0)
  {
    if (interactive)
      LogScreen( "%sThis client has been configured to run without\n"
                 "updating its buffers.\n",ffmsg);
    return -1;
  }

  dontfetch = dontflush = 1;
  if ((updatereq_flags & BUFFERUPDATE_FETCH) != 0)
    dontfetch = 0;
  if ((updatereq_flags & BUFFERUPDATE_FLUSH) != 0)
    dontflush = 0;

  dofetch = doflush = 0;  
  for (i = 0; i < CONTEST_COUNT; i++)
  {
    contest_i = (unsigned int)loadorder_map[i];
    loaderflags_map[i] = 0;
#ifndef GREGH
    if (contest_i == 2) 
      contest_i|=0x80;
#endif
    if (contest_i >= CONTEST_COUNT) /* disabled */
    {
      /* retrieve the original contest number from the load order */
      contest_i &= 0x7f;
      if (contest_i < CONTEST_COUNT)
        loaderflags_map[contest_i] = PROBLDR_DISCARD;  /* thus discardable */
    }
    else if (dofetch == 0 || doflush == 0)/* (contest_i < CONTEST_COUNT ) */
    {
      if (!dofetch && !dontfetch)
      {
        long count = GetBufferCount( contest_i, 0, NULL );
        if (count >= 0) /* no error */
        {
          if (count < ((long)(inthreshold[contest_i])) )
          {
            if (count <= 1 || connectoften || interactive)
              dofetch = 1;
          }
        }
      }
      if (!doflush && !dontflush)
      {
        long count = GetBufferCount( contest_i, 1 /* use_out_file */, NULL );
        if (count >= 0) /* no error */
        {
          if ( count > 0 /* count >= ((long)(outthreshold[contest_i])) || 
            ( connectoften && count > 0) || (interactive && count > 0) */)
          {
            doflush = 1;
          }
        }
      }
    }
  }
    
  failed = didfetch = didflush = 0;
  if ((doflush || dofetch) && CheckExitRequestTriggerNoIO() == 0)
  {
    if ( remote_update_dir[0] !=0 )
    {
      if (failed == 0 && !dontfetch && CheckExitRequestTriggerNoIO() == 0)
      {
        long transferred = BufferFetchFile( this, &loaderflags_map[0] );
        if (transferred < 0)
        {
          failed = 1;
          if (transferred < -1)
            didfetch = 1;
        }
        else if (transferred > 0)
          didfetch = 1;
      }
      if (failed == 0 && !dontflush && CheckExitRequestTriggerNoIO() == 0)
      {
        long transferred = BufferFlushFile( this, &loaderflags_map[0] );
        if (transferred < 0)
        {
          failed = 1;
          if (transferred < -1)
            didflush = 1;
        }
        else if (transferred > 0)
          didflush = 1;
      }
    }
  }

  ffmsg = "%sput buffers are %s. No %s required.\n";
  updatereq_flags = 0;
  if (didfetch)
    updatereq_flags |= BUFFERUPDATE_FETCH;
  else if (interactive && failed==0 && !dontfetch && !dofetch)
    LogScreen(ffmsg, "In", "full", "fetch");
  if (didflush)
    updatereq_flags |= BUFFERUPDATE_FLUSH;
  else if (interactive && failed==0 && !dontflush && !doflush)
    LogScreen(ffmsg, "Out", "empty", "flush");
  return (updatereq_flags);
}

/* --------------------------------------------------------------------- */

int BufferGetFileRecord( const char *filename, WorkRecord * data, 
               unsigned long *countP ) /* returns <0 on ioerr, >0 if norecs */
{                                      
  unsigned long reccount = 0;
  FILE *file = BufferOpenFile( filename, &reccount );
  int failed = -1;
  if ( file )
  {
    int canremove = 0;
    unsigned long recno = 0;
    WorkRecord blank, scratch;
    memset( (void *)&blank, 0, sizeof(blank) );
    failed = 0;
    if ( fseek( file, 0, SEEK_SET ) != 0)
      failed = -1;
    while (!failed && recno < reccount)
    {
      if ( fread( (void *)&scratch, sizeof(WorkRecord), 1, file ) != 1)
        failed = -1;
      else if ( 0 == memcmp( (void *)&scratch, (void *)&blank, sizeof(WorkRecord)) )
        ; /* blank record, ignore it */
      else if ( fseek( file, (recno * sizeof(WorkRecord)), SEEK_SET ) != 0)
        failed = -1;
      else if ( fwrite( (void *)&blank, sizeof(WorkRecord), 1, file ) != 1)
        failed = -1;
      else
        break; /* got it */
      recno++;
    }
    BufferCloseFile( file );
    if ( failed == 0 )
    {
      failed = +1;
      if (recno < reccount ) /* got it */
      {
        failed = 0;
        __switchborder( data, &scratch );
        if (reccount == 1)
          BufferZapFileRecords( filename );
      }
    }
  }
  if (!failed && countP)
    BufferCountFileRecords( filename, data->contest, countP, NULL );
  return failed;
}  

/* --------------------------------------------------------------------- */

int BufferCountFileRecords( const char *filename, unsigned int contest, 
                       unsigned long *countP, unsigned long *normcountP )
{
  unsigned long normcount = 0, reccount = 0;
  FILE *file = BufferOpenFile( filename, &reccount );
  int failed = -1;
  if ( file )
  {
    unsigned long packetcount = 0, recno = 0;
    WorkRecord blank, scratch;
    memset( (void *)&blank, 0, sizeof(blank) );
    failed = 0;
    if ( fseek( file, 0, SEEK_SET ) != 0)
      failed = -1;
    while (!failed && recno < reccount)
    {
      if ( fread( (void *)&scratch, sizeof(WorkRecord), 1, file ) != 1)
        failed = -1;
      else if ( 0 == memcmp( (void *)&scratch, (void *)&blank, sizeof(WorkRecord)) )
        ; /* blank record, ignore it */
      else if ( ((unsigned int)(scratch.contest)) == contest )
      {
        packetcount++
        if ( normcountP )
        {
          switch (contest) 
          {
            case 0: // RC5
            case 1: // DES
            {
              normcount += (unsigned int)
                 __iter2norm( ntohl(scratch.work.crypto.iterations.lo),
                              ntohl(scratch.work.crypto.iterations.hi) );
              break;
            }
            case 2: // OGR
            {
              normcount++;
              break;
            }
          }
        }
      }
      recno++;
    }
    reccount = packetcount;
    BufferClose( file );
  }
  if (failed != 0)
    normcount = reccount = 0;
  if (normcountP)
    *normcountP = normcount;
  if (packetcountP)
    *packetcountP = reccount;
  return failed;
}

#endif  /* SUPPRESS_FILE_BUFFER_PRIMITIVES */

/* ===================================================================== */
/*                         END OF FILE PRIMITIVES                        */
/* ===================================================================== */

static void __FixupRandomPrefix( const WorkRecord * data, Client *client )
{
  if (data->contest == 0 && data->work.crypto.iterations.hi == 0 /* < 2^32 */
     && (data->work.crypto.iterations.lo) != 0x00100000UL /*!test*/
     && (data->work.crypto.iterations.lo) != 0x10000000UL /* !2**28 */)
  {                                   
    u32 randomprefix = ((data->work.crypto.key.hi) & 0xFF000000L) >> 24;
    if (randomprefix != ((u32) client->randomprefix) ) 
    {
      // Has the high byte changed?  If so, then remember it.
      client->randomprefix = randomprefix;          
      client->randomchanged=1;
    }
  }
  return;
}

/* --------------------------------------------------------------------- */

static void __CheckBuffLimits( Client *client )
{
  unsigned int i;
  for (i=0;i<CONTEST_COUNT;i++)
  {
    if ( ((int)(client->inthreshold[i])) < 1 )
      client->inthreshold[i] = 1;
    else if ( ((int)(client->inthreshold[i])) > (int)(MAXBLOCKSPERBUFFER))
      client->inthreshold[i] = MAXBLOCKSPERBUFFER;
    if ( ((int)(client->outthreshold[i])) < 1 )
      client->outthreshold[i] = 1;
    else if ( client->outthreshold[i] > client->inthreshold[i])
      client->outthreshold[i] = client->inthreshold[i];
  }
  return;
}  

/* --------------------------------------------------------------------- */

long Client::PutBufferRecord(const WorkRecord *data)
{
  unsigned long workstate;
  unsigned int tmp_contest;
  membuffstruct *membuff;
  const char *filename;
  unsigned long count;
  int tmp_retcode, tmp_use_out_file;

  workstate = data->resultcode;
  tmp_contest = (unsigned int)data->contest;

  if (!(tmp_contest < CONTEST_COUNT))
  {
    //LogScreen("Discarded packet from unknown contest.\n");
  }
  else if (workstate != RESULT_WORKING && workstate != RESULT_FOUND && 
           workstate != RESULT_NOTHING)
  {
    LogScreen("Discarded packet with unrecognized workstate %ld.\n",workstate);
  }
  else
  {
    tmp_retcode = 0;
    count = 0;
    __FixupRandomPrefix( data, this );
    __CheckBuffLimits( this );

    if (workstate == RESULT_WORKING)
      tmp_use_out_file = 0;
    else
      tmp_use_out_file = 1;

    if (nodiskbuffers == 0)
    {
      filename = BufferGetDefaultFilename(tmp_contest, tmp_use_out_file,
        ((tmp_use_out_file) ? (out_buffer_basename) :(in_buffer_basename)) );
               /* returns <0 on ioerr, >0 if norecs */
      tmp_retcode = BufferPutFileRecord( filename, data, &count );
    }
    else
    {
      membuff = ((tmp_use_out_file) ?
          (&(membufftable[tmp_contest].out)) :
          (&(membufftable[tmp_contest].in)));
               /* returns <0 on ioerr, >0 if norecs */
      tmp_retcode = BufferPutMemRecord( membuff, data, &count );
    }
    if (tmp_retcode == 0)
      return (long)count;
    if (tmp_retcode < 0)
    {
      Log("Buffer seek/write error. Block discarded.\n");
    }
  }
  return -1;
}


/* --------------------------------------------------------------------- */

long Client::GetBufferRecord( WorkRecord* data, unsigned int contest, int use_out_file)
{
  unsigned long workstate;
  unsigned int tmp_contest;
  membuffstruct *membuff;
  const char *filename;
  unsigned long count;
  int retcode, tmp_retcode, tmp_use_out_file;

  __CheckBuffLimits( this );
  
  do
  {
    if (!(contest < CONTEST_COUNT))
    {
      break; /* return -1 */
    }
    else if (nodiskbuffers == 0)
    {
      filename = BufferGetDefaultFilename(contest, use_out_file,
          ((use_out_file) ? (out_buffer_basename) :(in_buffer_basename)) );
                 /* returns <0 on ioerr, >0 if norecs */
      retcode = BufferGetFileRecord( filename, data, &count );
//LogScreen("b:%d\n", retcode);
    }
    else
    {
      membuff = ((use_out_file)?
               (&(membufftable[contest].out)):(&(membufftable[contest].in)));
                 /* returns <0 on ioerr, >0 if norecs */
      retcode = BufferGetMemRecord( membuff, data, &count );
    }
    if ( retcode != 0)
    {
      if (retcode == -123 ) /* corrupted */
      {
        // corrupted - packet invalid, discard it.
        LogScreen( "Block integrity check failed. Block discarded.\n");
      }
      else if (retcode < 0) /* io error */
      {
        LogScreen("Buffer seek/read error. Partial packet discarded.\n");
        break; /* return -1; */
      }
    }
    else
    {
      workstate = ( data->resultcode );
      tmp_contest = (unsigned int)data->contest;
      if (!(tmp_contest < CONTEST_COUNT))
      {
        LogScreen("Discarded packet from unknown contest.\n");
      }
      else if (workstate != RESULT_WORKING && workstate != RESULT_FOUND && 
              workstate != RESULT_NOTHING)
      {
        LogScreen("Discarded packet with unrecognized workstate %ld.\n",workstate);
      }
      else if (tmp_contest != contest ||
               (use_out_file && workstate == RESULT_WORKING) ||
               (!use_out_file && workstate != RESULT_WORKING))
      {
        tmp_use_out_file = (workstate != RESULT_NOTHING);
        tmp_retcode = 0;
        LogScreen("Cross-saving packet of another type/contest.\n");
        if (nodiskbuffers == 0)
        {
          filename = BufferGetDefaultFilename(tmp_contest, tmp_use_out_file,
          ((tmp_use_out_file) ? (out_buffer_basename) :(in_buffer_basename)) );
                   /* returns <0 on ioerr, >0 if norecs */
          tmp_retcode = BufferPutFileRecord( filename, data, NULL );
        }
        else
        {
          membuff = ((tmp_use_out_file)?
           (&(membufftable[tmp_contest].out)):(&(membufftable[tmp_contest].in)));
                 /* returns <0 on ioerr, >0 if norecs */
          tmp_retcode = BufferPutMemRecord( membuff, data, NULL );
        }
        if (tmp_retcode < 0)
        {
          Log("Buffer seek/write error. Block discarded.\n");
        }
      }
      else /* packet is ok */
      {
        __FixupRandomPrefix( data, this );
        return (long)count; // all is well, data is a valid entry.
      }
    }
  /* bad packet, but loop if we have more in buff */
  } while (count && !CheckExitRequestTriggerNoIO()); 

  return -1;
}

/* --------------------------------------------------------------------- */

long Client::GetBufferCount( unsigned int contest, int use_out_file, unsigned long *normcountP )
{
  membuffstruct *membuff;
  const char *filename;
  unsigned long reccount = 0;
  int retcode = -1;

  __CheckBuffLimits( this );

  if (contest < CONTEST_COUNT)
  {
    if (nodiskbuffers == 0)
    {
      filename = BufferGetDefaultFilename(contest, use_out_file, 
        ((use_out_file) ? (out_buffer_basename) :(in_buffer_basename)) );
      retcode = BufferCountFileRecords( filename, contest, &reccount, normcountP );
    }
    else
    {
      membuff = ((use_out_file) ?
               (&(membufftable[contest].out)) :
               (&(membufftable[contest].in)));
      retcode = BufferCountMemRecords( membuff, contest, &reccount, normcountP );
    }
  }
  if (retcode != 0 && normcountP)
    *normcountP = 0;

  return ((retcode!=0)?(-1):((long)reccount));
}

/* --------------------------------------------------------------------- */

/* import records from source, return -1 if err, or number of recs imported. */
/* On success, source is truncated/deleted. Used by checkpt and --import */
long BufferImportFileRecords( Client *client, const char *source_file )
{
  unsigned long remaining, lastremaining = 0;
  unsigned recovered = 0;
  WorkRecord data; 

  if ( !DoesFileExist( source_file ) )
    return -1L;
  
  while (BufferGetFileRecord( source_file, &data, &remaining ) == 0) 
                           //returns <0 on ioerr/corruption, > 0 if norecs
  {
    if (lastremaining != 0)
    {
      if (lastremaining <= remaining)
      {
        recovered = 0;
        break;
      }
    }
    lastremaining = remaining;
    if ( client->PutBufferRecord( &data ) > 0 )
    {
      recovered++;              
    }
  }
  if (recovered > 0)
    BufferZapFileRecords( source_file );
  return recovered;
}

/* --------------------------------------------------------------------- */

long BufferFlushFile( Client *client, const char *loadermap_flags )
{
  long combinedtrans = 0, combinedworkunits = 0;
  const char *exchname = "Flush::";
  char basename[128];
  unsigned int contest;
  int failed = 0;
  
  if (client->remote_update_dir[0] == '\0')
    return -1;
  strncpy( basename, 
           GetFullPathForFilenameAndDir(
             &(client->out_buffer_basename[
                        GetFilenameBaseOffset(client->out_buffer_basename)]),
             client->remote_update_dir ), 
          sizeof(basename) );
  basename[sizeof(basename)-1] = '\0';
    
  for (contest = 0; failed == 0  && contest < CONTEST_COUNT; contest++)
  {
    WorkRecord wrdata;
    unsigned long projtrans = 0;
    long lefttotrans;
    char remote_file[128];

    if (CheckExitRequestTriggerNoIO())  
      break;

    if (loadermap_flags[contest] != 0) /* contest is closed or disabled */
      continue;
  
    strncpy( remote_file, BufferGetDefaultFilename(contest,1,basename), sizeof(remote_file));
    remote_file[sizeof(remote_file)-1] = '\0';

    while ((lefttotrans = client->GetBufferRecord( &wrdata, contest, 1 )) >= 0)
    {
      long workunits = 0;

      if (( wrdata.resultcode != RESULT_NOTHING && 
            wrdata.resultcode != RESULT_FOUND ) || 
            ((unsigned int)wrdata.contest) != contest)
      { /* buffer code should have handled this */
        Log( "%sError - Bad Data - packet discarded.\n",exchname );
        continue;
      }
      
      if ( BufferPutFileRecord( remote_file, &wrdata, NULL ) != 0 )
      {
        client->PutBufferRecord( &wrdata );
        failed = -1;
        break;
      }
      
      switch (contest) 
      {
        case 0: // RC5
        case 1: // DES
          workunits =  __iter2norm(wrdata.work.crypto.iterations.lo,
                                   wrdata.work.crypto.iterations.hi);
          break;
        case 2: // OGR
          workunits = 1;                   
          break;
      }
      
      projtrans++;
      combinedtrans++;
      combinedworkunits += workunits;

      struct Fetch_Flush_Info ffinfo = {contest, projtrans, combinedtrans};
      ClientEventSyncPost(CLIEVENT_BUFFER_FLUSHFLUSHED, (long)(&ffinfo));

      unsigned long totrans = (projtrans + (unsigned long)(lefttotrans));
      unsigned int percent = ((totrans>projtrans)?((projtrans*10000)/totrans):(10000));
      LogScreen( "\rSent %s packet %lu of %lu (%u.%02u%% transferred)     ",
          CliGetContestNameFromID(contest),
          projtrans, (totrans > projtrans ? totrans : projtrans),
          percent/100, percent%100 );
    
      if (CheckExitRequestTriggerNoIO())  
        break;

    } /* while (lefttotrans >=0 ) */
    
  } /* for (contest = 0; contest < CONTEST_COUNT; contest++) */

  if (combinedtrans > 0)
  {
    ClientEventSyncPost( CLIEVENT_BUFFER_FLUSHEND, (long)(combinedtrans) );
    Log( "Moved %lu packet%s (%lu work units) to remote file.\n", 
      combinedtrans, ((combinedtrans==1)?(""):("s")), combinedworkunits );
  }

  return (failed ? (- (long)(combinedtrans+1)) : (combinedtrans));
}
        
/* --------------------------------------------------------------------- */

long BufferFetchFile( Client *client, const char *loaderflags_map )
{
  unsigned long combinedtrans = 0, combinedworkunits = 0;
  const char *exchname = "Fetch::";
  char basename[128];
  unsigned int contest;
  int failed = 0;

  if (client->remote_update_dir[0] == '\0')
    return -1;
  strncpy( basename, 
           GetFullPathForFilenameAndDir(
             &(client->in_buffer_basename[
                        GetFilenameBaseOffset(client->in_buffer_basename)]),
             client->remote_update_dir ), 
          sizeof(basename) );
  basename[sizeof(basename)-1] = '\0';
//printf("basename: %s\n",basename);
    
  for (contest = 0; !failed && contest < CONTEST_COUNT; contest++)
  {
    unsigned long projtrans = 0;
    long lefttotrans;
    char remote_file[128];

    if (CheckExitRequestTriggerNoIO())  
      break;

    if (loaderflags_map[contest] != 0) /* contest is closed or disabled */
      continue;

    lefttotrans = (long)client->GetBufferCount( contest, 0, NULL );

    if ((lefttotrans >= 0) && (((unsigned long)(lefttotrans)) < 
              ((unsigned long)(client->inthreshold[contest]))) ) 
      lefttotrans = ((long)(client->inthreshold[contest])) - lefttotrans;
    else
      lefttotrans = 0;

    if (lefttotrans != 0)
    {
      strncpy( remote_file, BufferGetDefaultFilename(contest,1,basename), sizeof(remote_file));
      remote_file[sizeof(remote_file)-1] = '\0';
      if (!DoesFileExist(remote_file))
        lefttotrans = 0;
//printf("remotefile: %s %ld\n",remote_file,lefttotrans);
    }

    while (lefttotrans > 0 )
    {
      WorkRecord wrdata;
      unsigned long remaining;
      int workunits = 0;
      
      if (CheckExitRequestTriggerNoIO() != 0 )
        break;

      if ( BufferGetFileRecord( remote_file, &wrdata, &remaining ) != 0 )
        break;
      if (remaining < lefttotrans)
        lefttotrans = remaining;
      
      if (client->PutBufferRecord( &wrdata ) < 0)
      {
        BufferPutFileRecord( remote_file, &wrdata, NULL );
        failed = -1;
        break;
      }
      
      switch (contest) 
      {
        case 0: // RC5
        case 1: // DES
          workunits =  __iter2norm(wrdata.work.crypto.iterations.lo,
                                   wrdata.work.crypto.iterations.hi);
          break;
        case 2: // OGR
          workunits = 1;                   
          break;
      }

      projtrans++;
      combinedtrans++;
      combinedworkunits+=workunits;

      if (combinedtrans == 1) 
        ClientEventSyncPost( CLIEVENT_BUFFER_FETCHBEGIN, 0 );
        
      struct Fetch_Flush_Info ffinfo = {contest, projtrans, combinedtrans};
      ClientEventSyncPost( CLIEVENT_BUFFER_FETCHFETCHED, (long)(&ffinfo) );
  
      unsigned long totrans = (projtrans + (unsigned long)(lefttotrans));
      unsigned int percent = ((totrans)?((projtrans*10000)/totrans):(10000));
      LogScreen( "\rRetrieved %s packet %lu of %lu (%u.%02u%% transferred) ",
        CliGetContestNameFromID(contest),
        projtrans, (totrans)?(totrans):(projtrans), percent/100, percent%100 );
    }  /* while ( lefttotrans > 0  ) */
    
  } /* for (contest = 0; contest < CONTEST_COUNT; contest++) */

  if (combinedtrans > 0)
  {
    ClientEventSyncPost( CLIEVENT_BUFFER_FETCHEND, (long)(combinedtrans) );
    Log( "Retrieved %lu packet%s (%lu work units) from remote file.\n", 
      combinedtrans, ((combinedtrans==1)?(""):("s")), 
      combinedworkunits );
  }

  return (failed ? (- (long) (combinedtrans+1)) : (combinedtrans));
}
