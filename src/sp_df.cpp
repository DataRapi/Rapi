
#include "Rapi.h"
namespace Rapi
{
  class sp_data_frame
  {
  protected:
    Rc_df  df;
  public:
    sp_data_frame(Rc_df &df_)
    {
      df = df_;
    }
    Rc_df get_df()
    {
      return df;
    }
    sp_data_frame operator=(Rc_df &df_)
    {
      df = df_;
      return *this;
    }
    vector_string tag_names_checked(const Rc_vec_char & tag_names)
    {
      vector_string tag_names_c;
      for (const auto &tag_name : tag_names)
      {
          s_string tag_name_s = s_string(tag_name) ;
        if (col_exists(tag_name_s))
          tag_names_c.push_back(s_string(tag_name));
      }
      return tag_names_c;
    }
    template <class T, class U>
    bool str_equal(T t, U u)
    {
      std::string t1(t);
      std::string u1(u);
      return t1 == u1;
    }
    Rc_df remove_column_df(const Rc_df &df1, const s_string &column_name)
    {
      Rc_df ndf = clone(df1);
      auto cols = get_col_names(df1);
      for (int i = 0; i < cols.size(); i++)
      {
        if (str_equal(column_name, cols[i]))
        {
          ndf.erase(i);
        }
      }
      return ndf;
    }
    void remove_column( const s_string & column_name)
    {
      df = remove_column_df(df, column_name);
    }
    Rc_df &transform_df_cpp_internal(const Rc_list &  lag_list)
    {
        Rc_vec_char a1 =  lag_list.names() ;
      vector_string tag_names_c = tag_names_checked(a1);
      if (tag_names_c.size() == 0)
        return df;
      for (const auto &name : tag_names_c)
      {
        Rc_vec_num lag_range = lag_list[s_string(name)];
        for (const auto &x : lag_range)
        {
            s_string name_s = s_string(name) ;
          add_new_col( name_s , x);
        }
      }
      return df;
    }
    Rc_vec_num get_column(s_string& col_name)
    {
      return df[col_name];
    }
    void set_column(s_string col_name, Rc_vec_num &v)
    {
      df[col_name] = v;
    }
    Rc_vec_num copy_column(s_string &col_name)
    {
      return clone(get_column(col_name));
    }
    void add_new_col(  s_string  & col_name, int lag)
    {
      auto vec_y = copy_column(col_name);
      s_string n_col_name = col_name + "_lag_" + std::to_string(lag);
      auto new_col_vals =  lag_ekle_v(vec_y, lag);
      set_column(n_col_name, new_col_vals );
    }
    template <class T>
    void dummy(T &smt)
    {
    }
    Rc_vec_num lag_ekle_v(Rc_vec_num & v, int lag)
    {
      int i = -1;
      auto v1 = clone(v);
      for (auto x : v1)
      {
        dummy(x);
        i++;
        if (i < lag)
        {
          v1[i] = NA_REAL;
        }
        else
        {
          v1[i] = v[i - lag];
        }
      }
      return v1;
    }
    Rc_vec_char get_col_names(const Rc_df &dfx) { return dfx.names(); }
    Rc_vec_char get_col_names() { return df.names(); }
    //............................... col_exists
    bool col_exists(s_string & col_name)
    {
      for (const auto &x : get_col_names())
      {
        s_string a(x);
        if (a == col_name)
        {
          return true;
        }
      }
      return false;
    }
  };
}
